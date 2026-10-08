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
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Helper;
using Google.Apis.Logging;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries
{
    public record GetByIdQuery(int IdSolicitud) : IRequest<Result<SolicitudRepartidorDto>>;
    
   
    public class GetByIdHandler(IUnitofWork context, IRepository<CuentaBancaria> _cuentas) : IRequestHandler<GetByIdQuery, Result<SolicitudRepartidorDto>>
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

            int cuentaId = solicitud.DatosRepartidor.IdCuentaBancaria;
            CuentaBancaria? cuenta = null;
            if (cuentaId > 0)
            {
                cuenta = await _cuentas.FirstOrDefaultAsync(c=>c.IdCuenta == cuentaId,
                    includes: b=> b.Banco, cancellationToken:cancellationToken);
            }

            var dto = SolicitudHelper.ToDto(solicitud, cuenta);
            
            return Result<SolicitudRepartidorDto>.Success(200, dto, "Solicitud encontrada", true);
        }
    }
}
