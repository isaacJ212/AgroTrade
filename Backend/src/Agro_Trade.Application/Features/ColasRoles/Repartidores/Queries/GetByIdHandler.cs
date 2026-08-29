using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries
{
    public record GetByIdQuery(int IdSolicitud) : IRequest<Result<SolicitudRepartidorDto>>;
    
   
    public class GetByIdHandler(IUnitofWork context) : IRequestHandler<GetByIdQuery, Result<SolicitudRepartidorDto>>
    {
        public async Task<Result<SolicitudRepartidorDto>> Handle(GetByIdQuery request, CancellationToken cancellationToken)
        {
            if(request.IdSolicitud <= 0)
            {
                return Result<SolicitudRepartidorDto>.Failure(400, "Id Solicitud inválido");
            }
            var solicitud = await context.SolicitudRepartidor.GetByIdAsync(request.IdSolicitud, cancellationToken);
            if (solicitud == null)
            {
                return Result<SolicitudRepartidorDto>.Failure(404, "Solicitud no encontrada");
            }
            var dto = ToDto(solicitud);
            return Result<SolicitudRepartidorDto>.Success(200, dto, "Solicitud encontrada", true);
        }
        public SolicitudRepartidorDto ToDto(SolicitudRepartidor solicitud)
        {
            return new SolicitudRepartidorDto
            {
                IdSolicitud = solicitud.IdSolicitud,
                IdUsuario = solicitud.IdUsuario,
                NombreUsuario = solicitud.Usuario?.NombreCompleto ?? string.Empty,
                DatosRepartidor = solicitud.DatosRepartidor,
                Estado = solicitud.Estado,
                FechaSolicitud = solicitud.FechaSolicitud,
                Departamento = solicitud.DatosRepartidor?.Departamento?? ""
            };
        }
    }
}
