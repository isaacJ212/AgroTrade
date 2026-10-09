using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.SuscripcionesDtos;
using Agro_Trade.Application.Common.Interface;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Suscripciones.Queries
{
    public class SuscripcionAdminDto : SuscripcionDto
    {
        public string NombreUsuario { get; set; } = string.Empty;
    }

    public record GetAllSuscripcionesQuery() : IRequest<Result<List<SuscripcionAdminDto>>>;

    public class GetAllSuscripcionesHandler(IUnitofWork unitOfWork) : IRequestHandler<GetAllSuscripcionesQuery, Result<List<SuscripcionAdminDto>>>
    {
        public async Task<Result<List<SuscripcionAdminDto>>> Handle(GetAllSuscripcionesQuery request, CancellationToken ct)
        {
            var suscripciones = await unitOfWork.Suscripciones.GetQueryable()
                .Include(s => s.Usuario)
                .Include(s => s.TipoPlan)
                .OrderByDescending(s => s.FechaInicio)
                .ToListAsync(ct);

            var mapped = suscripciones.Select(s => new SuscripcionAdminDto
            {
                IdSuscripcionApp = s.IdSuscripcionApp,
                IdUsuario = s.IdUsuario,
                TipoPlan = s.TipoPlan?.NombrePlan ?? string.Empty,
                TarifaPago = s.TarifaPago,
                Estado = s.Estado,
                FechaInicio = s.FechaInicio,
                FechaFin = s.FechaFin,
                RenovacionAutomatica = s.RenovacionAutomatica,
                CreadaEn = s.CreadaEn,
                NombreUsuario = $"{s.Usuario?.Nombre} {s.Usuario?.PrimerApellido} {s.Usuario?.SegundoApellido}".Trim()
            }).ToList();

            return Result<List<SuscripcionAdminDto>>.Success(200, mapped, "Exito", true);
        }
    }

    public record SuscripcionMetricsDto(int Activas, int Canceladas, decimal IngresosGenerados);
    public record GetSuscripcionesMetricsQuery() : IRequest<Result<SuscripcionMetricsDto>>;

    public class GetSuscripcionesMetricsHandler(IUnitofWork unitOfWork) : IRequestHandler<GetSuscripcionesMetricsQuery, Result<SuscripcionMetricsDto>>
    {
        public async Task<Result<SuscripcionMetricsDto>> Handle(GetSuscripcionesMetricsQuery request, CancellationToken ct)
        {
            var suscripciones = await unitOfWork.Suscripciones.GetQueryable().ToListAsync(ct);

            var activas = suscripciones.Count(s => s.Estado == "Activa");
            var canceladas = suscripciones.Count(s => s.Estado == "Cancelada");
            var ingresos = suscripciones.Sum(s => s.TarifaPago);

            var metrics = new SuscripcionMetricsDto(activas, canceladas, ingresos);

            return Result<SuscripcionMetricsDto>.Success(200, metrics, "Exito", true);
        }
    }
}
