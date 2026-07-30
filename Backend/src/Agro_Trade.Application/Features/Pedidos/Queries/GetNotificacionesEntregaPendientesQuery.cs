using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Queries
{
    public record GetNotificacionesEntregaPendientesQuery(int UsuarioRepartidorId) : IRequest<Result<List<NotificacionEntregaDto>>>;

    public class GetNotificacionesEntregaPendientesHandler(
        IRepository<NotificacionEntrega> notificacionRepository,
        IRepository<Pedido> pedidoRepository) : IRequestHandler<GetNotificacionesEntregaPendientesQuery, Result<List<NotificacionEntregaDto>>>
    {
        public async Task<Result<List<NotificacionEntregaDto>>> Handle(GetNotificacionesEntregaPendientesQuery request, CancellationToken cancellationToken)
        {
            if (request.UsuarioRepartidorId <= 0)
                return Result<List<NotificacionEntregaDto>>.Failure(400, "El repartidor es invalido.");

            var notificaciones = await notificacionRepository.FindAsync(
                n => n.IdUsuarioRepartidor == request.UsuarioRepartidorId && n.Estado == "PENDIENTE",
                cancellationToken);

            var resultado = new List<NotificacionEntregaDto>();
            foreach (var notificacion in notificaciones)
            {
                var pedido = await pedidoRepository.GetByIdAsync(notificacion.IdPedido, cancellationToken);
                if (pedido is not null)
                    resultado.Add(new NotificacionEntregaDto
                    {
                        PedidoId = pedido.IdPedido,
                        ZonaEntrega = notificacion.ZonaEntrega,
                        TotalPedido = pedido.Total,
                        FechaCreacion = notificacion.FechaCreacion
                    });
            }

            return Result<List<NotificacionEntregaDto>>.Success(200, resultado, "Notificaciones obtenidas.", true);
        }
    }
}
