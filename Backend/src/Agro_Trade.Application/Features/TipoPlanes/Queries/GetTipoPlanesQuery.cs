using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.TipoPlanes.Queries
{
    public class TipoPlanDto
    {
        public int IdTipoPlan { get; set; }
        public string NombrePlan { get; set; } = null!;
        public string Descripcion { get; set; } = null;
        public string Beneficios { get; set; } = null!;
        public decimal Precio { get; set; }
        public decimal Coste { get; set; }
        public bool Estado { get; set; }
    }

    public sealed record GetTipoPlanesQuery() : IRequest<Result<IEnumerable<TipoPlanDto>>>;

    public class GetTipoPlanesHandler(IUnitofWork unitOfWork) : IRequestHandler<GetTipoPlanesQuery, Result<IEnumerable<TipoPlanDto>>>
    {
        public async Task<Result<IEnumerable<TipoPlanDto>>> Handle(GetTipoPlanesQuery request, CancellationToken ct)
        {
            var result = await unitOfWork.TipoPlanes.GetQueryable()
                .Select(p => new TipoPlanDto
                {
                    IdTipoPlan = p.Id,
                    NombrePlan = p.NombrePlan,
                    Descripcion = p.Descripcion,
                    Beneficios = p.Beneficios,
                    Precio = p.Precio,
                    Coste = p.Coste,
                    Estado = p.IsActive
                }).ToListAsync(ct);

            return Result<IEnumerable<TipoPlanDto>>.Success(200, result, "Planes obtenidos con éxito.", true);
        }
    }
}
