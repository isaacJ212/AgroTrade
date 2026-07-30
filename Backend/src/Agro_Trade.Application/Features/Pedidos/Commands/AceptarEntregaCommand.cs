using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Commands
{
    public record AceptarEntregaCommand(int PedidoId, int UsuarioRepartidorId) : IRequest<Result>;

    public class AceptarEntregaCommandHandler(
        IRepository<NotificacionEntrega> notificacionRepository,
        IRepository<Repartidor> repartidorRepository,
        IRepository<LogisticaEntrega> logisticaRepository,
        IUnitofWork unitOfWork) : IRequestHandler<AceptarEntregaCommand, Result>
    {
        public async Task<Result> Handle(AceptarEntregaCommand request, CancellationToken cancellationToken)
        {
            if (request.PedidoId <= 0 || request.UsuarioRepartidorId <= 0)
                return Result.Failure(400, "Pedido y repartidor son requeridos.");

            var notificacion = await notificacionRepository.FirstOrDefaultAsync(
                n => n.IdPedido == request.PedidoId && n.IdUsuarioRepartidor == request.UsuarioRepartidorId && n.Estado == "PENDIENTE",
                cancellationToken);
            if (notificacion is null)
                return Result.Failure(404, "No hay una oferta de entrega pendiente para este repartidor.");

            var repartidor = await repartidorRepository.FirstOrDefaultAsync(
                r => r.IdUsuario == request.UsuarioRepartidorId,
                cancellationToken);
            if (repartidor is null || repartidor.Estado != "DISPONIBLE")
                return Result.Failure(409, "El repartidor no esta disponible.");

            if (await logisticaRepository.FirstOrDefaultAsync(l => l.IdPedido == request.PedidoId, cancellationToken) is not null)
                return Result.Failure(409, "El pedido ya fue aceptado por otro repartidor.");

            try
            {
                await unitOfWork.BeginTransactionAsync(cancellationToken);
                repartidor.Estado = "EN ENTREGA";
                notificacion.Estado = "ACEPTADA";
                await repartidorRepository.UpdateAsync(repartidor, cancellationToken);
                await notificacionRepository.UpdateAsync(notificacion, cancellationToken);
                await logisticaRepository.AddAsync(new LogisticaEntrega
                {
                    IdPedido = request.PedidoId,
                    IdUsuarioRepartidor = request.UsuarioRepartidorId,
                    EstadoActual = "ASIGNADA"
                }, cancellationToken);

                var ofertasPendientes = await notificacionRepository.FindAsync(
                    n => n.IdPedido == request.PedidoId && n.IdNotificacion != notificacion.IdNotificacion && n.Estado == "PENDIENTE",
                    cancellationToken);
                foreach (var oferta in ofertasPendientes)
                {
                    oferta.Estado = "CERRADA";
                    await notificacionRepository.UpdateAsync(oferta, cancellationToken);
                }

                await unitOfWork.CommitAsync(cancellationToken);
                return Result.Success(200, "Entrega aceptada y asignada al repartidor.");
            }
            catch
            {
                await unitOfWork.RollbackAsync(cancellationToken);
                return Result.Failure(409, "No fue posible asignar la entrega; puede haber sido aceptada por otro repartidor.");
            }
        }
    }
}
