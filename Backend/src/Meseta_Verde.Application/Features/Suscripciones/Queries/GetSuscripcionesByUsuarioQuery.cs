using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Suscripciones.Queries
{

    public record GetSuscripcionesByUsuarioQuery(int IdUsuario) : IRequest<Result<List<SuscripcionDto>>>;


    public class GetSuscripcionesByUsuarioQueryHandler : IRequestHandler<GetSuscripcionesByUsuarioQuery, Result<List<SuscripcionDto>>>
    {
        private readonly IUnitofWork _unitOfWork;


        public GetSuscripcionesByUsuarioQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }


        public async Task<Result<List<SuscripcionDto>>> Handle(GetSuscripcionesByUsuarioQuery request, CancellationToken ct)
        {

            var suscripciones = await _unitOfWork.Suscripciones.FindAsync(
                s => s.IdUsuario == request.IdUsuario, ct);


            if (suscripciones == null || !suscripciones.Any())
                return Result<List<SuscripcionDto>>.Success(200, new List<SuscripcionDto>(), "El usuario no posee historial de suscripciones.", true);


            var historial = suscripciones
                .OrderByDescending(s => s.FechaInicio)
                .Select(s => new SuscripcionDto
                {
                    IdSuscripcionApp = s.IdSuscripcionApp,
                    IdUsuario = s.IdUsuario,
                    TipoPlan = s.TipoPlan,
                    TarifaPago = s.TarifaPago,
                    Estado = s.Estado,
                    FechaInicio = s.FechaInicio,
                    FechaFin = s.FechaFin,
                    RenovacionAutomatica = s.RenovacionAutomatica,
                    CreadaEn = s.CreadaEn
                }).ToList();
                

            return Result<List<SuscripcionDto>>.Success(200, historial, "Historial de suscripciones obtenido con éxito.", true);
        }


    }
}