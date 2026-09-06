using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Commands
{
    public record ProcesarCompraDirectaCommand(int UserId, List<CartItemDto> Items, string MetodoPago) : IRequest<Result<CheckoutResponseDto>>;

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
            if (request.Items == null || !request.Items.Any() || string.IsNullOrWhiteSpace(request.MetodoPago))
                return Result<CheckoutResponseDto>.Failure(400, "Los datos de compra son invalidos o el carrito está vacío.");

            if (request.UserId <= 0)
                 return Result<CheckoutResponseDto>.Failure(401, "No se pudo identificar el usuario de la sesión.");

            var cliente = await usuarioRepository.GetByIdAsync(request.UserId, cancellationToken);
            if (cliente is null)
                return Result<CheckoutResponseDto>.Failure(404, "El usuario cliente no existe.");

            var detalles = new List<DetallePedido>();
            var transferenciasAGenerar = new Dictionary<string, (decimal Monto, string Banco, string Cuenta)>();
            decimal totalGeneral = 0;
            var inventariosAActualizar = new List<InventarioProveedor>();

            foreach (var item in request.Items)
            {
                if (item.ProductId <= 0 || item.Quantity <= 0)
                    return Result<CheckoutResponseDto>.Failure(400, "Un producto tiene datos inválidos en el carrito.");

                var producto = await productoRepository.FirstOrDefaultAsync(
                    p => p.IdProducto == item.ProductId,
                    cancellationToken,
                    p => p.Proveedor,
                    p => p.Inventarios);

                if (producto is null)
                    return Result<CheckoutResponseDto>.Failure(404, $"El producto con ID {item.ProductId} no existe.");

                var inventario = producto.Inventarios.FirstOrDefault(i => i.IdProveedor == producto.IdProveedor && i.Disponible);
                if (inventario is null || inventario.StockActual < item.Quantity)
                    return Result<CheckoutResponseDto>.Failure(409, $"El producto '{producto.Nombre}' no tiene stock suficiente.");

                var descuento = Math.Clamp((decimal)(inventario.PorcentajeDescuento ?? 0), 0m, 100m);
                var precioUnitario = inventario.PrecioVenta * (1m - descuento / 100m);
                var subtotal = precioUnitario * item.Quantity;

                totalGeneral += subtotal;

                detalles.Add(new DetallePedido
                {
                    IdInventario = inventario.IdInventario,
                    Cantidad = item.Quantity,
                    PrecioUnitario = (float)precioUnitario,
                    Subtotal = subtotal
                });

                inventario.StockActual -= item.Quantity;
                if (inventario.StockActual <= 0) inventario.Disponible = false;
                inventariosAActualizar.Add(inventario);

                var proveedorNombre = producto.Proveedor.NombreProveedor;
                if (transferenciasAGenerar.ContainsKey(proveedorNombre))
                {
                    var actual = transferenciasAGenerar[proveedorNombre];
                    transferenciasAGenerar[proveedorNombre] = (actual.Monto + subtotal, actual.Banco, actual.Cuenta);
                }
                else
                {
                    transferenciasAGenerar[proveedorNombre] = (subtotal, producto.Proveedor.Banco, producto.Proveedor.CuentaBancaria);
                }
            }

            var pedido = new Pedido
            {
                IdUsuarioCliente = request.UserId,
                FechaPedido = DateTime.UtcNow,
                Total = totalGeneral,
                MetodoPago = request.MetodoPago.Trim(),
                EstadoPago = "PAGADO",
                EstadoEnvio = "PENDIENTE"
            };

            try
            {
                await unitOfWork.BeginTransactionAsync(cancellationToken);
                
                // Guardar Pedido
                await pedidoRepository.AddAsync(pedido, cancellationToken);
                await unitOfWork.SaveChangesAsync(cancellationToken);

                // Guardar Detalles
                foreach (var detalle in detalles)
                {
                    detalle.IdPedido = pedido.IdPedido;
                    await detallePedidoRepository.AddAsync(detalle, cancellationToken);
                }

                // Actualizar Inventarios
                foreach (var inv in inventariosAActualizar)
                {
                    await inventarioRepository.UpdateAsync(inv, cancellationToken);
                }

                // Notificar Repartidores
                int repartidoresNotificados = 0;
                var zonaEntrega = cliente.Departamento?.Trim();
                if (!string.IsNullOrEmpty(zonaEntrega))
                {
                    var repartidoresDisponibles = await repartidorRepository.FindAsync(r => r.Estado == "DISPONIBLE" && r.Departamento.ToLower().Contains(zonaEntrega.ToLower()), cancellationToken);
                    foreach (var rep in repartidoresDisponibles)
                    {
                        await notificacionRepository.AddAsync(new NotificacionEntrega
                        {
                            IdPedido = pedido.IdPedido,
                            IdUsuarioRepartidor = rep.IdUsuario,
                            ZonaEntrega = cliente.DireccionBase ?? $"En {cliente.Departamento}"
                        }, cancellationToken);
                        repartidoresNotificados++;
                    }
                }

                // Crear Transferencias
                var dtosTransferencias = new List<TransferenciaCheckoutDto>();
                foreach (var kvp in transferenciasAGenerar)
                {
                    var transferencia = new RegistroTransferenciaMock
                    {
                        IdTransferencia = Guid.NewGuid().ToString("N"),
                        IdPedido = pedido.IdPedido,
                        Proveedor = kvp.Key,
                        BancoDestino = kvp.Value.Banco,
                        Cuenta = kvp.Value.Cuenta,
                        MontoEnviado = kvp.Value.Monto,
                        Estado = "LIQUIDADO_ACH_EXITOSO"
                    };
                    await transferenciaRepository.AddAsync(transferencia, cancellationToken);
                    
                    dtosTransferencias.Add(new TransferenciaCheckoutDto
                    {
                        IdTransferencia = transferencia.IdTransferencia,
                        Proveedor = transferencia.Proveedor,
                        MontoEnviado = transferencia.MontoEnviado,
                        Estado = transferencia.Estado
                    });
                }

                await unitOfWork.SaveChangesAsync(cancellationToken);
                await unitOfWork.CommitAsync(cancellationToken);

                return Result<CheckoutResponseDto>.Success(201, new CheckoutResponseDto
                {
                    PedidoId = pedido.IdPedido,
                    Total = totalGeneral,
                    TotalProductores = totalGeneral, // Simplified for this logic
                    MetodoPago = pedido.MetodoPago!,
                    RepartidoresNotificados = repartidoresNotificados,
                    Transferencias = dtosTransferencias
                }, "Compra directa procesada correctamente.", true);
            }
            catch
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return Result<CheckoutResponseDto>.Failure(500, "No fue posible procesar la compra.");
            }
        }
    }
}
