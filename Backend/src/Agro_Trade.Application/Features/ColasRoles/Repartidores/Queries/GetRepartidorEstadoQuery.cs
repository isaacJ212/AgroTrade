using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries
{
    public record GetRepartidorEstadoQuery(int UsuarioId) : IRequest<Result<RepartidorEstadoDto>>;

    public class RepartidorEstadoDto
    {
        public bool TieneRepartidor { get; set; }
        public string? SolicitudEstado { get; set; }
        public string? ComentarioModerador { get; set; }
        public int? RepartidorId { get; set; }
    }

    public class GetRepartidorEstadoHandler(
        IUnitofWork context,
        IRepository<Repartidor> repartidores,
        IRepository<SolicitudRepartidor> solicitudes) : IRequestHandler<GetRepartidorEstadoQuery, Result<RepartidorEstadoDto>>
    {
        public async Task<Result<RepartidorEstadoDto>> Handle(GetRepartidorEstadoQuery request, CancellationToken cancellationToken)
        {
            // 1. Verificar si ya es repartidor aprobado
            var repartidor = await repartidores.FirstOrDefaultAsync(
                r => r.IdUsuario == request.UsuarioId, 
                cancellationToken: cancellationToken);

            if (repartidor != null)
            {
                return Result<RepartidorEstadoDto>.Success(200, new RepartidorEstadoDto
                {
                    TieneRepartidor = true,
                    RepartidorId = repartidor.Id,
                    SolicitudEstado = "Aprobada"
                }, "Repartidor verificado", true);
            }

            // 2. Verificar si tiene solicitud pendiente/rechazada
            var solicitud = await solicitudes.FirstOrDefaultAsync(
                s => s.IdUsuario == request.UsuarioId,
                cancellationToken: cancellationToken);

            if (solicitud != null)
            {
                return Result<RepartidorEstadoDto>.Success(200, new RepartidorEstadoDto
                {
                    TieneRepartidor = false,
                    SolicitudEstado = solicitud.Estado,
                    ComentarioModerador = null // El comentario se envía por email, no se persiste en BD
                }, "Estado de solicitud obtenido", true);
            }

            // 3. No tiene nada - necesita onboarding
            return Result<RepartidorEstadoDto>.Success(200, new RepartidorEstadoDto
            {
                TieneRepartidor = false,
                SolicitudEstado = null
            }, "Sin solicitud previa", true);
        }
    }
}