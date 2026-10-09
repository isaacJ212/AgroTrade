using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Suscripciones.Queries
{
    public class TransaccionSuscripcionDto
    {
        public int IdSuscripcion { get; set; }
        public int IdUsuario { get; set; }
        public string NombreUsuario { get; set; } = null!;
        public string Plan { get; set; } = null!;
        public decimal MontoPagado { get; set; }
        public DateTime FechaTransaccion { get; set; }
        public string Estado { get; set; } = null!;
    }

    public sealed record GetTransaccionesSuscripcionQuery() : IRequest<Result<IEnumerable<TransaccionSuscripcionDto>>>;

    public class GetTransaccionesSuscripcionHandler(IUnitofWork unitOfWork) : IRequestHandler<GetTransaccionesSuscripcionQuery, Result<IEnumerable<TransaccionSuscripcionDto>>>
    {
        public async Task<Result<IEnumerable<TransaccionSuscripcionDto>>> Handle(GetTransaccionesSuscripcionQuery request, CancellationToken ct)
        {
            var result = await unitOfWork.Suscripciones.GetQueryable()
                .Include(s => s.Usuario)
                .Include(s => s.TipoPlan)
                .OrderByDescending(s => s.FechaInicio)
                .Select(s => new TransaccionSuscripcionDto
                {
                    IdSuscripcion = s.IdSuscripcionApp,
                    IdUsuario = s.IdUsuario,
                    NombreUsuario = $"{s.Usuario.Nombre} {s.Usuario.PrimerApellido} {s.Usuario.SegundoApellido}".Trim(),
                    Plan = s.TipoPlan.NombrePlan,
                    MontoPagado = s.TarifaPago,
                    FechaTransaccion = s.CreadaEn,
                    Estado = s.Estado ?? "Activo"
                }).ToListAsync(ct);

            return Result<IEnumerable<TransaccionSuscripcionDto>>.Success(200, result, "Historial de transacciones de suscripciones obtenido con éxito.", true);
        }
    }
}
