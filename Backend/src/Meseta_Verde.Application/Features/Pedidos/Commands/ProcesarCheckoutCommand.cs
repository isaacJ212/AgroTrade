using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Pedidos.Commands
{
    public record ProcesarCheckoutCommand(int UserId, string MetodoPago) : IRequest<Result<CheckoutResponseDto>>;

    public class ProcesarCheckoutHandler(
        ICartRepository cartRepository,
        IRepository<Producto> productoRepository,
        IRepository<InventarioProveedor> inventarioRepository,
        IRepository<Pedido> pedidoRepository,
        IRepository<RegistroTransferenciaMock> transferenciaRepository,
        IRepository<Usuario> usuarioRepository,
        IRepository<Repartidor> repartidorRepository,
        IRepository<NotificacionEntrega> notificacionEntregaRepository,
        IUnitofWork unitOfWork) : IRequestHandler<ProcesarCheckoutCommand, Result<CheckoutResponseDto>>
    {
        private const decimal ComisionPorcentaje = 0.12m;
        private const string EstadoTransferenciaExitosa = "LIQUIDADO_ACH_EXITOSO";
        private const decimal ComisionRepartidorFija = 50.00m;

        public async Task<Result<CheckoutResponseDto>> Handle(ProcesarCheckoutCommand request, CancellationToken cancellationToken)
        {
            if (request.UserId <= 0 || string.IsNullOrWhiteSpace(request.MetodoPago))
                return Result<CheckoutResponseDto>.Failure(400, "Usuario y metodo de pago son requeridos.");

            var cart = await cartRepository.GetCart(request.UserId);
            if (cart.Items.Count == 0)
                return Result<CheckoutResponseDto>.Failure(400, "No es posible procesar un carrito vacio.");

            var cliente = await usuarioRepository.GetByIdAsync(request.UserId, cancellationToken);
            if (cliente is null)
                return Result<CheckoutResponseDto>.Failure(404, "El usuario cliente no existe.");

            var lineas = new List<CheckoutLine>();
            foreach (var item in cart.Items)
            {
                if (item.Quantity <= 0)
                    return Result<CheckoutResponseDto>.Failure(400, "La cantidad de cada producto debe ser mayor que cero.");

                var producto = await productoRepository.FirstOrDefaultAsync(
                    p => p.IdProducto == item.ProductId,
                    cancellationToken,
                    p => p.Proveedor,
                    p => p.Inventarios);

                if (producto is null)
                    return Result<CheckoutResponseDto>.Failure(404, $"No se encontro el producto {item.ProductId}.");

                var inventario = producto.Inventarios.FirstOrDefault(i =>
                    i.IdProveedor == producto.IdProveedor && i.Disponible);
                if (inventario is null)
                    return Result<CheckoutResponseDto>.Failure(409, $"El producto {producto.Nombre} no esta disponible.");
                if (inventario.StockActual < item.Quantity)
                    return Result<CheckoutResponseDto>.Failure(409, $"Stock insuficiente para {producto.Nombre}.");

                var descuento = Math.Clamp((decimal)(inventario.PorcentajeDescuento ?? 0), 0m, 100m);
                var precioUnitario = inventario.PrecioVenta * (1m - descuento / 100m);
                lineas.Add(new CheckoutLine(producto, inventario, item.Quantity, precioUnitario * item.Quantity));
            }

            var subtotal = lineas.Sum(linea => linea.Subtotal); 
            var total = subtotal - ComisionRepartidorFija;
            var pedido = new Pedido
            {
                IdUsuarioCliente = request.UserId,
                FechaPedido = DateTime.UtcNow,
                MetodoPago = request.MetodoPago.Trim(),
                EstadoPago = "PAGADO",
                EstadoEnvio = "PENDIENTE",
                Total = total
            };

            try
            {
                await unitOfWork.BeginTransactionAsync(cancellationToken);
                await pedidoRepository.AddAsync(pedido, cancellationToken);
                await unitOfWork.SaveChangesAsync(cancellationToken);

                var repartidoresNotificados = 0;
                var zonaEntrega = cliente.Departamento?.Trim();
                if (!string.IsNullOrWhiteSpace(zonaEntrega))
                {
                    var repartidoresDisponibles = await repartidorRepository.FindAsync(
                        r => r.Estado == "DISPONIBLE" && r.Departamento.ToLower().Contains(zonaEntrega.ToLower()),
                        cancellationToken);

                    foreach (var repartidor in repartidoresDisponibles)
                    {
                        await notificacionEntregaRepository.AddAsync(new NotificacionEntrega
                        {
                            IdPedido = pedido.IdPedido,
                            IdUsuarioRepartidor = repartidor.IdUsuario,
                            ZonaEntrega = zonaEntrega
                        }, cancellationToken);
                        repartidoresNotificados++;
                    }
                }

                var transferencias = new List<TransferenciaCheckoutDto>();
                foreach (var linea in lineas)
                {
                    linea.Inventario.StockActual -= linea.Cantidad;
                    if (linea.Inventario.StockActual <= 0)
                        linea.Inventario.Disponible = false;
                    await inventarioRepository.UpdateAsync(linea.Inventario, cancellationToken);

                    var montoProveedor = Math.Round(linea.Subtotal * (1m - ComisionPorcentaje), 2, MidpointRounding.AwayFromZero);
                    var transferencia = new RegistroTransferenciaMock
                    {
                        IdTransferencia = Guid.NewGuid().ToString("N"),
                        IdPedido = pedido.IdPedido,
                        Proveedor = linea.Producto.Proveedor.NombreProveedor,
                        BancoDestino = linea.Producto.Proveedor.Banco,
                        Cuenta = linea.Producto.Proveedor.CuentaBancaria,
                        MontoEnviado = montoProveedor,
                        Estado = EstadoTransferenciaExitosa
                    };
                    await transferenciaRepository.AddAsync(transferencia, cancellationToken);
                    transferencias.Add(new TransferenciaCheckoutDto
                    {
                        IdTransferencia = transferencia.IdTransferencia,
                        Proveedor = transferencia.Proveedor,
                        MontoEnviado = transferencia.MontoEnviado,
                        Estado = transferencia.Estado
                    });
                }

                await unitOfWork.CommitAsync(cancellationToken);
                await cartRepository.ClearCart(request.UserId);

                var totalProductores = transferencias.Sum(t => t.MontoEnviado);
                return Result<CheckoutResponseDto>.Success(201, new CheckoutResponseDto
                {
                    PedidoId = pedido.IdPedido,
                    Total = total,
                    ComisionPlataforma = total - totalProductores,
                    TotalProductores = totalProductores,
                    MetodoPago = pedido.MetodoPago,
                    RepartidoresNotificados = repartidoresNotificados,
                    Transferencias = transferencias
                }, "Checkout procesado correctamente.", true);
            }
            catch
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return Result<CheckoutResponseDto>.Failure(500, "No fue posible procesar el checkout.");
            }
        }

        private sealed record CheckoutLine(Producto Producto, InventarioProveedor Inventario, int Cantidad, decimal Subtotal);
    }
}
