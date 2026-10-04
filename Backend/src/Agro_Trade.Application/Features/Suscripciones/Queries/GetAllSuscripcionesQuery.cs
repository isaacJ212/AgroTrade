using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Agro_Trade.Application.Common.DTOs.SuscripcionesDtos;

namespace Agro_Trade.Application.Features.Suscripciones.Queries
{
    public class SuscripcionAdminDto
    {
        public int IdSuscripcion { get; set; }
        public int IdUsuario { get; set; }
        public int IdPlan { get; set; }
        public string NombrePlan { get; set; } = null!;
        public decimal PrecioPlan { get; set; }
        public string TipoIntervalo { get; set; } = null!;
        public System.DateTime FechaInicio { get; set; }
        public System.DateTime? FechaFin { get; set; }
        public string? Estado { get; set; }
        public string NombreUsuario { get; set; } = null!;
    }

    public sealed record GetAllSuscripcionesQuery(int? RoleId) : IRequest<Result<IEnumerable<SuscripcionAdminDto>>>;

    public class GetAllSuscripcionesHandler(IUnitofWork unitOfWork) : IRequestHandler<GetAllSuscripcionesQuery, Result<IEnumerable<SuscripcionAdminDto>>>
    {
        public async Task<Result<IEnumerable<SuscripcionAdminDto>>> Handle(GetAllSuscripcionesQuery request, CancellationToken ct)
        {
            IQueryable<SuscripcionApp> query = unitOfWork.Suscripciones.GetQueryable()
                .Include(s => s.Usuario)
                .Include(s => s.TipoPlan);

            if (request.RoleId.HasValue)
            {
                // This checks if the user has the specified role
                query = query.Where(s => s.Usuario.UsuariosRoles.Any(ur => ur.IdRol == request.RoleId.Value));
            }

            var result = await query.Select(s => new SuscripcionAdminDto
            {
                IdSuscripcion = s.IdSuscripcionApp,
                IdUsuario = s.IdUsuario,
                IdPlan = s.IdPlan,
                NombrePlan = s.TipoPlan.NombrePlan,
                PrecioPlan = s.TipoPlan.Precio,
                TipoIntervalo = "Mensual",
                FechaInicio = s.FechaInicio,
                FechaFin = s.FechaFin,
                Estado = s.Estado,
                NombreUsuario = s.Usuario.Nombre + " " + s.Usuario.PrimerApellido
            }).ToListAsync(ct);

            return Result<IEnumerable<SuscripcionAdminDto>>.Success(200, result, "Suscripciones obtenidas con éxito.", true);
        }
    }
}
