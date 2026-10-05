using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Suscripciones.Queries
{
    public class SuscripcionesMetricsDto
    {
        public int TotalSuscripciones { get; set; }
        public int SuscripcionesActivas { get; set; }
        public decimal IngresosTotales { get; set; }
        public decimal IngresosMensualesEstimados { get; set; }
    }

    public sealed record GetSuscripcionesMetricsQuery() : IRequest<Result<SuscripcionesMetricsDto>>;

    public class GetSuscripcionesMetricsHandler(IUnitofWork unitOfWork) : IRequestHandler<GetSuscripcionesMetricsQuery, Result<SuscripcionesMetricsDto>>
    {
        public async Task<Result<SuscripcionesMetricsDto>> Handle(GetSuscripcionesMetricsQuery request, CancellationToken ct)
        {
            var query = unitOfWork.Suscripciones.GetQueryable().Include(s => s.TipoPlan);

            var total = await query.CountAsync(ct);
            var activas = await query.CountAsync(s => s.Estado == "Activo" || s.Estado == "activa" || s.Estado == "Activa", ct);
            var ingresosTotales = await query.SumAsync(s => (decimal?)s.TipoPlan.Precio, ct) ?? 0m;
            
            var mensuales = await query
                .Where(s => s.Estado == "Activo" || s.Estado == "activa" || s.Estado == "Activa")
                .SumAsync(s => (decimal?)s.TipoPlan.Precio, ct) ?? 0m;

            var metrics = new SuscripcionesMetricsDto
            {
                TotalSuscripciones = total,
                SuscripcionesActivas = activas,
                IngresosTotales = ingresosTotales,
                IngresosMensualesEstimados = mensuales
            };

            return Result<SuscripcionesMetricsDto>.Success(200, metrics, "Métricas obtenidas con éxito.", true);
        }
    }
}
