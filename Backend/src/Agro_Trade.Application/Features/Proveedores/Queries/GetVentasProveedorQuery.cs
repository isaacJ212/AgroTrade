using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProveedoresDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Proveedores.Queries
{
    public record GetVentasProveedorQuery(int UserId) : IRequest<Result<List<VentaProveedorDto>>>;

    public class GetVentasProveedorHandler(
        IRepository<Proveedor> proveedorRepository,
        IRepository<DetallePedido> detallePedidoRepository,
        IRepository<Producto> productoRepository,
        IRepository<Pedido> pedidoRepository) : IRequestHandler<GetVentasProveedorQuery, Result<List<VentaProveedorDto>>>
    {
        public async Task<Result<List<VentaProveedorDto>>> Handle(GetVentasProveedorQuery request, CancellationToken cancellationToken)
        {
            if (request.UserId <= 0)
                return Result<List<VentaProveedorDto>>.Failure(400, "El usuario es invalido.");
            
            var proveedor = await proveedorRepository.FirstOrDefaultAsync(p => p.IdUsuario == request.UserId, cancellationToken);
            if (proveedor is null)
                return Result<List<VentaProveedorDto>>.Failure(404, "No existe un proveedor asociado al usuario.");

            var detalles = await detallePedidoRepository.FindAsync(
                d => d.Inventario.IdProveedor == proveedor.IdProveedor,
                cancellationToken,
                d => d.Inventario);

            var ventas = new List<VentaProveedorDto>();
            foreach (var detalle in detalles)
            {
                var producto = await productoRepository.GetByIdAsync(detalle.Inventario.IdProducto, cancellationToken);
                var pedido = await pedidoRepository.GetByIdAsync(detalle.IdPedido, cancellationToken);
                if (producto is null || pedido is null) continue;

                ventas.Add(new VentaProveedorDto
                {
                    IdPedido = detalle.IdPedido,
                    IdDetallePedido = detalle.IdDetallePedido,
                    Producto = producto.Nombre,
                    Cantidad = detalle.Cantidad,
                    Subtotal = detalle.Subtotal,
                    NetoProveedor = Math.Round(detalle.Subtotal * 0.88m, 2, MidpointRounding.AwayFromZero),
                    FechaPedido = pedido.FechaPedido
                });
            }

            return Result<List<VentaProveedorDto>>.Success(200, ventas.OrderByDescending(v => v.FechaPedido).ToList(), "Ventas obtenidas correctamente.", true);
        }
    }
}
