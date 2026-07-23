using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Pedidos.Commands
{
    public record ProcesarCompraDirectaCommand(int UserId, int ProductId, int Quantity, string MetodoPago) : IRequest<Result<CheckoutResponseDto>>;

    public class ProcesarCompraDirectaHandler(
        IRepository<Usuario> usuarioRepository,
        IRepository<Producto> productoRepository,
        IRepository<InventarioProveedor> inventarioRepository,
        IRepository<Pedido> pedidoRepository,
        IRepository<NotificacionEntrega> notificacionRepository,
        IRepository<Repartidor> repartidorRepository,
        IRepository<DetallePedido> detallePedidoRepository,
        IRepository<RegistroTransferenciaMock> transferenciaRepository,
        IUnitofWork unitOfWork) : IRequestHandler<ProcesarCompraDirectaCommand, Result<CheckoutResponseDto>>
    {
        public async Task<Result<CheckoutResponseDto>> Handle(ProcesarCompraDirectaCommand request, CancellationToken cancellationToken)
        {
            if (request.UserId <= 0 || request.ProductId <= 0 || request.Quantity <= 0 || string.IsNullOrWhiteSpace(request.MetodoPago))
                return Result<CheckoutResponseDto>.Failure(400, "Los datos de compra son invalidos.");

            if (await usuarioRepository.GetByIdAsync(request.UserId, cancellationToken) is null)
                return Result<CheckoutResponseDto>.Failure(404, "El usuario cliente no existe.");

            var producto = await productoRepository.FirstOrDefaultAsync(
                p => p.IdProducto == request.ProductId,
                cancellationToken,
                p => p.Proveedor,
                p => p.Inventarios);
            if (producto is null)
                return Result<CheckoutResponseDto>.Failure(404, "El producto no existe.");

            var inventario = producto.Inventarios.FirstOrDefault(i => i.IdProveedor == producto.IdProveedor && i.Disponible);
            if (inventario is null || inventario.StockActual < request.Quantity)
                return Result<CheckoutResponseDto>.Failure(409, "El producto no tiene stock suficiente.");

            var descuento = Math.Clamp((decimal)(inventario.PorcentajeDescuento ?? 0), 0m, 100m);
            var precioUnitario = inventario.PrecioVenta * (1m - descuento / 100m);
            var subtotal = precioUnitario * request.Quantity;
            var pedido = new Pedido
            {
                IdUsuarioCliente = request.UserId,
                FechaPedido = DateTime.UtcNow,
                Total = subtotal,
                MetodoPago = request.MetodoPago.Trim(),
                EstadoPago = "PAGADO",
                EstadoEnvio = "PENDIENTE"
            };

            try
            {
                await unitOfWork.BeginTransactionAsync(cancellationToken);
                await pedidoRepository.AddAsync(pedido, cancellationToken);
                await unitOfWork.SaveChangesAsync(cancellationToken);

                await detallePedidoRepository.AddAsync(new DetallePedido
                {
                    IdPedido = pedido.IdPedido,
                    IdInventario = inventario.IdInventario,
                    Cantidad = request.Quantity,
                    PrecioUnitario = (float)precioUnitario,
                    Subtotal = subtotal
                }, cancellationToken);

                inventario.StockActual -= request.Quantity;
                if (inventario.StockActual <= 0) inventario.Disponible = false;
                await inventarioRepository.UpdateAsync(inventario, cancellationToken);

                int repartidoresNotificados = 0;
                var cliente = await usuarioRepository.FirstOrDefaultAsync(u => u.IdUsuario == request.UserId, cancellationToken);
                var zonaEntrega = cliente.Departamento?.Trim();
                if (!string.IsNullOrEmpty(zonaEntrega))
                {
                  var  repartidoresDisponibles = await  repartidorRepository.FindAsync(r => r.Estado == "DISPONIBLE" && r.Departamento.ToLower().Contains(zonaEntrega.ToLower()), cancellationToken);
                    foreach(var rep in repartidoresDisponibles)
                    {
                        await notificacionRepository.AddAsync(new NotificacionEntrega
                        {
                            IdPedido = pedido.IdPedido,
                            IdUsuarioRepartidor = rep.IdUsuario,
                            ZonaEntrega = cliente.DireccionBase?? $"En {cliente.Departamento}"
                        }, cancellationToken);
                        repartidoresNotificados++;
                    }
                }

               
                var transferencia = new RegistroTransferenciaMock
                {
                    IdTransferencia = Guid.NewGuid().ToString("N"),
                    IdPedido = pedido.IdPedido,
                    Proveedor = producto.Proveedor.NombreProveedor,
                    BancoDestino = producto.Proveedor.Banco,
                    Cuenta = producto.Proveedor.CuentaBancaria,
                    MontoEnviado = subtotal,
                    Estado = "LIQUIDADO_ACH_EXITOSO"
                };
                await transferenciaRepository.AddAsync(transferencia, cancellationToken);
                await unitOfWork.SaveChangesAsync(cancellationToken);
                await unitOfWork.CommitAsync(cancellationToken);

                return Result<CheckoutResponseDto>.Success(201, new CheckoutResponseDto
                {
                    PedidoId = pedido.IdPedido,
                    Total = subtotal,
                    TotalProductores = subtotal,
                    MetodoPago = pedido.MetodoPago!,
                    RepartidoresNotificados = repartidoresNotificados,
                    Transferencias = [new TransferenciaCheckoutDto
                    {
                        IdTransferencia = transferencia.IdTransferencia,
                        Proveedor = transferencia.Proveedor,
                        MontoEnviado = subtotal,
                        Estado = transferencia.Estado
                    }]
                }, "Compra directa procesada correctamente.", true);
            }
            catch
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return Result<CheckoutResponseDto>.Failure(500, "No fue posible procesar la compra directa.");
            }
        }
    }
}
