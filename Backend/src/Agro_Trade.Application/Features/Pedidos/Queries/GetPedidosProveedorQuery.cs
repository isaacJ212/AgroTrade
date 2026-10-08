using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Queries
{
    // DTO extendido para el productor (incluye nombre del cliente)
    public class PedidoProveedorDto
    {
        public int IdPedido { get; set; }
        public DateTime FechaPedido { get; set; }
        public decimal Total { get; set; }
        public string? EstadoEnvio { get; set; }
        public string? EstadoPago { get; set; }
        public string? MetodoPago { get; set; }
        public string NombreCliente { get; set; } = string.Empty;
        public int IdUsuarioCliente { get; set; }
        public ICollection<DetallePedidoDto> Detalles { get; set; } = new List<DetallePedidoDto>();
    }

    public sealed record GetPedidosProveedorQuery(int UsuarioId) : IRequest<Result<List<PedidoProveedorDto>>>;

    public class GetPedidosProveedorHandler(
        IRepository<Pedido> pedidoRepo,
        IRepository<DetallePedido> detalleRepo,
        IRepository<Proveedor> proveedorRepo)
        : IRequestHandler<GetPedidosProveedorQuery, Result<List<PedidoProveedorDto>>>
    {
        public async Task<Result<List<PedidoProveedorDto>>> Handle(
            GetPedidosProveedorQuery request, CancellationToken ct)
        {
            if (request.UsuarioId <= 0)
                return Result<List<PedidoProveedorDto>>.Failure(400, "Usuario inválido.");

            // Buscar el proveedor asociado al usuario
            var proveedor = await proveedorRepo.FirstOrDefaultAsync(
                p => p.IdUsuario == request.UsuarioId, ct);

            if (proveedor is null)
                return Result<List<PedidoProveedorDto>>.Failure(404, "No se encontró proveedor para este usuario.");

            // Obtener detalles donde el inventario pertenece al proveedor
            var detalles = await detalleRepo.FindAsync(
                d => d.Inventario.IdProveedor == proveedor.IdProveedor,
                ct,
                "Pedido.UsuarioCliente",
                "Inventario.Producto.UnidadDeMedida");

            // Agrupar por pedido
            var pedidoIds = detalles.Select(d => d.IdPedido).Distinct().ToList();

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
                        NombreCliente = pedido.UsuarioCliente != null ? $"{pedido.UsuarioCliente.Nombre} {pedido.UsuarioCliente.PrimerApellido}".Trim() : $"Cliente #{pedido.IdUsuarioCliente}",
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
                $"{resultado.Count} pedidos encontrados para proveedor {request.UsuarioId}.", true);
        }
    }
}
