using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Queries
{
    public sealed record GetPedidosPendientesProveedorQuery(int UsuarioId) : IRequest<Result<List<PedidoProveedorDto>>>;

    public class GetPedidosPendientesProveedorHandler(
        IRepository<Pedido> pedidoRepo,
        IRepository<DetallePedido> detalleRepo,
        IRepository<Proveedor> proveedorRepo)
        : IRequestHandler<GetPedidosPendientesProveedorQuery, Result<List<PedidoProveedorDto>>>
    {
        private static readonly HashSet<string> _estadosPendientes = new(StringComparer.OrdinalIgnoreCase)
        {
            "PENDIENTE", "PREPARANDO"
        };

        public async Task<Result<List<PedidoProveedorDto>>> Handle(
            GetPedidosPendientesProveedorQuery request, CancellationToken ct)
        {
            if (request.UsuarioId <= 0)
                return Result<List<PedidoProveedorDto>>.Failure(400, "Usuario inválido.");

            // Buscar el proveedor asociado al usuario
            var proveedor = await proveedorRepo.FirstOrDefaultAsync(
                p => p.IdUsuario == request.UsuarioId, ct);
            
            if (proveedor is null)
                return Result<List<PedidoProveedorDto>>.Failure(404, "No se encontró proveedor para este usuario.");

            // Obtener detalles donde el inventario pertenece al proveedor
            // y el pedido está en estado pendiente/preparando
            var detalles = await detalleRepo.FindAsync(
                d => d.Inventario.IdProveedor == proveedor.IdProveedor 
                  && _estadosPendientes.Contains(d.Pedido.EstadoEnvio ?? ""),
                ct,
                "Pedido.UsuarioCliente",
                "Inventario.Producto.UnidadDeMedida");

            if (!detalles.Any())
                return Result<List<PedidoProveedorDto>>.Success(200, new List<PedidoProveedorDto>(), 
                    "No hay pedidos pendientes para este proveedor.", true);

            // Agrupar por pedido
            var resultado = detalles
                .GroupBy(d => d.IdPedido)
                .Select(g =>
                {
                    var primerDetalle = g.First();
                    var pedido = primerDetalle.Pedido;
                    return new PedidoProveedorDto
                    {
                        IdPedido = pedido.IdPedido,
                        FechaPedido = pedido.FechaPedido,
                        Total = g.Sum(d => d.Subtotal),
                        EstadoEnvio = pedido.EstadoEnvio,
                        EstadoPago = pedido.EstadoPago,
                        MetodoPago = pedido.MetodoPago,
                        NombreCliente = pedido.UsuarioCliente != null 
                            ? $"{pedido.UsuarioCliente.Nombre} {pedido.UsuarioCliente.PrimerApellido}".Trim() 
                            : $"Cliente #{pedido.IdUsuarioCliente}",
                        IdUsuarioCliente = pedido.IdUsuarioCliente,
                        Detalles = g.Select(d => new DetallePedidoDto
                        {
                            Id = d.IdDetallePedido,
                            PedidoId = d.IdPedido,
                            IdProducto = d.Inventario.IdProducto,
                            Producto = d.Inventario.Producto.Nombre,
                            UnidadMedida = d.Inventario.Producto.UnidadDeMedida?.Codigo ?? "und",
                            Cantidad = d.Cantidad,
                            PrecioUnitario = (decimal)d.PrecioUnitario,
                            TotalLinea = d.Subtotal
                        }).ToList()
                    };
                })
                .OrderByDescending(p => p.FechaPedido)
                .ToList();

            return Result<List<PedidoProveedorDto>>.Success(200, resultado,
                $"{resultado.Count} pedidos pendientes encontrados.", true);
        }
    }
}