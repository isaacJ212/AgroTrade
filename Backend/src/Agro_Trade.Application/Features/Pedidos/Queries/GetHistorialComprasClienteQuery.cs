using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Common.Interface;


namespace Agro_Trade.Application.Features.Pedidos.Queries
{
    public record GetHistorialComprasClienteQuery(int UserId) : IRequest<Result<List<PedidoClienteDto>>>;

    public class GetHistorialComprasClienteHandler(IRepository<Pedido> pedidoRepository) : IRequestHandler<GetHistorialComprasClienteQuery, Result<List<PedidoClienteDto>>>
    {
        public async Task<Result<List<PedidoClienteDto>>> Handle(GetHistorialComprasClienteQuery request, CancellationToken cancellationToken)
        {
            if (request.UserId <= 0)
                return Result<List<PedidoClienteDto>>.Failure(400, "El usuario es invalido.");

            var pedidos = await pedidoRepository.FindAsync(p => p.IdUsuarioCliente == request.UserId, cancellationToken, "Detalles.Inventario.Producto");
            var data = pedidos.OrderByDescending(p => p.FechaPedido).Select(p => new PedidoClienteDto
            {
                IdPedido = p.IdPedido,
                FechaPedido = p.FechaPedido,
                Total = p.Total,
                MetodoPago = p.MetodoPago,
                EstadoPago = p.EstadoPago,
                EstadoEnvio = p.EstadoEnvio,
                Detalles = p.Detalles.Select(p => new DetallePedidoDto
                {
                    Id = p.IdDetallePedido,
                    PedidoId = p.IdPedido,
                    Producto = p.Inventario.Producto.Nombre,
                    Cantidad = p.Cantidad,
                    TotalLinea = p.Subtotal
                }).ToList()
            }).ToList();

            return Result<List<PedidoClienteDto>>.Success(200, data, "Historial de compras obtenido correctamente.", true);
        }
    }
}
