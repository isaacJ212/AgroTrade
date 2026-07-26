using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Pedidos.Commands
{
    public record ConfirmarPagoPedidoCommand(int PedidoId, string TransaccionPasarelaId) : IRequest<Result<bool>>;

    public class ConfirmarPagoPedidoHandler(
        IRepository<Pedido> pedidoRepository,
        IRepository<Usuario> usuarioRepository,
        IRepository<Repartidor> repartidorRepository,
        IRepository<NotificacionEntrega> notificacionEntregaRepository,
        IRepository<InventarioProveedor> inventarioRepository,
        IRepository<Producto> productoRepository,
        IRepository<RegistroTransferenciaMock> transferenciaRepository,
        ICartRepository cartRepository,
        IUnitofWork unitOfWork) : IRequestHandler<ConfirmarPagoPedidoCommand, Result<bool>>
    {
        private const string EstadoTransferenciaExitosa = "A ESPERA DE PAGO";

        public async Task<Result<bool>> Handle(ConfirmarPagoPedidoCommand request, CancellationToken cancellationToken)
        {
            // 1. Buscamos el pedido original (usando la nueva sobrecarga de strings que creamos para traer los productos)
            var pedidos = await pedidoRepository.FindAsync(
                p => p.IdPedido == request.PedidoId && p.EstadoPago == "PENDIENTE",
                cancellationToken,
                "Detalles.Inventario.Producto.Proveedor"
            );

            var pedido = pedidos.FirstOrDefault();
            if (pedido is null)
                return Result<bool>.Failure(404, "El pedido no existe o ya fue procesado.");

            var cliente = await usuarioRepository.GetByIdAsync(pedido.IdUsuarioCliente, cancellationToken);
            if (cliente is null)
                return Result<bool>.Failure(404, "El cliente asociado al pedido no existe.");

            try
            {
                await unitOfWork.BeginTransactionAsync(cancellationToken);

                // 2. Actualizamos el estado del Pedido con la confirmación de la pasarela
                pedido.EstadoPago = "PAGADO";
                // pedido.IdTransaccionPasarela = request.TransaccionPasarelaId; // Si tienes este campo en tu BD
                await pedidoRepository.UpdateAsync(pedido, cancellationToken);

                // 3. Notificar Repartidores de la zona
                var zonaEntrega = cliente.Departamento?.Trim();
                if (!string.IsNullOrWhiteSpace(zonaEntrega))
                {
                    var repartidoresDisponibles = await repartidorRepository.FindAsync(
                        r => r.Estado == "DISPONIBLE" && r.Departamento.Contains(zonaEntrega, StringComparison.OrdinalIgnoreCase),
                        cancellationToken);

                    foreach (var repartidor in repartidoresDisponibles)
                    {
                        await notificacionEntregaRepository.AddAsync(new NotificacionEntrega
                        {
                            IdPedido = pedido.IdPedido,
                            IdUsuarioRepartidor = repartidor.IdUsuario,
                            ZonaEntrega = zonaEntrega
                        }, cancellationToken);
                    }
                }

                // 4. Reducir Stock Real y Generar Transferencias Mocks a Proveedores
                foreach (var detalle in pedido.Detalles)
                {
                    var inventario = detalle.Inventario;

                    // Descontamos del stock físico real
                    inventario.StockActual -= detalle.Cantidad;
                    if (inventario.StockActual <= 0)
                        inventario.Disponible = false;

                    await inventarioRepository.UpdateAsync(inventario, cancellationToken);

                    // Generamos el registro de transferencia para el productor
                    var transferencia = new RegistroTransferenciaMock
                    {
                        IdTransferencia = Guid.NewGuid().ToString("N"),
                        IdPedido = pedido.IdPedido,
                        Proveedor = inventario.Producto.Proveedor.NombreProveedor,
                        BancoDestino = inventario.Producto.Proveedor.Banco,
                        Cuenta = inventario.Producto.Proveedor.CuentaBancaria,
                        MontoEnviado = detalle.Subtotal,
                        Estado = EstadoTransferenciaExitosa
                    };

                    await transferenciaRepository.AddAsync(transferencia, cancellationToken);
                }

                await unitOfWork.CommitAsync(cancellationToken);

                // 5. Limpiamos el carrito del usuario ya que la compra fue 100% exitosa
                await cartRepository.ClearCart(pedido.IdUsuarioCliente);

                return Result<bool>.Success(200, true, "Pago confirmado e inventario actualizado correctamente.", true);
            }
            catch
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return Result<bool>.Failure(500, "Error crítico al procesar la confirmación del pago.");
            }
        }
    }
}
  
