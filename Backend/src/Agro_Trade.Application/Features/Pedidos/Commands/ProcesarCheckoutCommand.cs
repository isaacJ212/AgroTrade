using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Commands
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
        
        private const string EstadoTransferenciaExitosa = "A ESPERA DE PAGO";
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
            var detallesPedido = new List<DetallePedido>(); // Para guardarlos en el Pedido inicial

            foreach (var item in cart.Items)
            {
                if (item.Quantity <= 0)
                    return Result<CheckoutResponseDto>.Failure(400, "La cantidad de cada producto debe ser mayor que cero.");

                var producto = await productoRepository.FirstOrDefaultAsync(
                    p => p.IdProducto == item.ProductId, cancellationToken, p => p.Proveedor, p => p.Inventarios);

                if (producto is null)
                    return Result<CheckoutResponseDto>.Failure(404, $"No se encontro el producto {item.ProductId}.");

                var inventario = producto.Inventarios.FirstOrDefault(i => i.IdProveedor == producto.IdProveedor && i.Disponible);
                if (inventario is null)
                    return Result<CheckoutResponseDto>.Failure(409, $"El producto {producto.Nombre} no esta disponible.");

                // Validación preventiva de Stock
                if (inventario.StockActual < item.Quantity)
                    return Result<CheckoutResponseDto>.Failure(409, $"Stock insuficiente para {producto.Nombre}.");

                var descuento = Math.Clamp((decimal)(inventario.PorcentajeDescuento ?? 0), 0m, 100m);
                var precioUnitario = inventario.PrecioVenta * (1m - descuento / 100m);
                var subtotalLinea = precioUnitario * item.Quantity;

                lineas.Add(new CheckoutLine(producto, inventario, item.Quantity, subtotalLinea));

                // Agregamos el detalle al pedido (asumiendo que tu entidad Pedido tiene una colección de Detalles)
                detallesPedido.Add(new DetallePedido
                {
                    IdInventario = inventario.IdInventario,
                    Cantidad = item.Quantity,
                    PrecioUnitario = (float)precioUnitario,
                    Subtotal = subtotalLinea
                });
            }

            var subtotal = lineas.Sum(linea => linea.Subtotal);
            // Nota: Si vas a SUMAR la comisión del repartidor al cliente, debería ser + ComisionRepartidorFija
            var total = subtotal + ComisionRepartidorFija;

            var pedido = new Pedido
            {
                IdUsuarioCliente = request.UserId,
                FechaPedido = DateTime.UtcNow,
                MetodoPago = request.MetodoPago.Trim(),
                EstadoPago = "PENDIENTE", // <--- Esencial: Nace pendiente de pasarela
                EstadoEnvio = "PENDIENTE",
                Total = total,
                Detalles = detallesPedido // Guardamos la estructura completa del carrito congelada en el pedido
            };

            try
            {
                await unitOfWork.BeginTransactionAsync(cancellationToken);
                await pedidoRepository.AddAsync(pedido, cancellationToken);
                await unitOfWork.SaveChangesAsync(cancellationToken);
                await unitOfWork.CommitAsync(cancellationToken);

                // Devolvemos los datos para que el frontend arme el botón de PayPal con el Total exacto y el PedidoId
                return Result<CheckoutResponseDto>.Success(201, new CheckoutResponseDto
                {
                    PedidoId = pedido.IdPedido,
                    Total = total,
                    TotalProductores = subtotal, // Los productores cobran sobre el subtotal de productos
                    MetodoPago = pedido.MetodoPago,
                    RepartidoresNotificados = 0, // Se notificarán real y formalmente en el paso 2
                    Transferencias = new List<TransferenciaCheckoutDto>() // Se calculan en la confirmación
                }, "Checkout pre-procesado correctamente. En espera de pago.", true);
            }
            catch
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return Result<CheckoutResponseDto>.Failure(500, "No fue posible pre-procesar el checkout.");
            }
        }

        private sealed record CheckoutLine(Producto Producto, InventarioProveedor Inventario, int Cantidad, decimal Subtotal);
    }
}
