using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.SuscripcionesDtos;
using Agro_Trade.Application.Common.Interface;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Suscripciones.Queries
{
    public class GetTiposPlanesQuery : IRequest<Result<List<TipoPlanDto>>>
    {
    }

    public class GetTiposPlanesQueryHandler : IRequestHandler<GetTiposPlanesQuery, Result<List<TipoPlanDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetTiposPlanesQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<TipoPlanDto>>> Handle(GetTiposPlanesQuery request, CancellationToken cancellationToken)
        {
            var query = _unitOfWork.TipoPlanes.GetQueryable();

            var planes = await query
                .Where(p => p.IsActive)
                .Select(p => new TipoPlanDto
                {
                    Id = p.Id,
                    NombrePlan = p.NombrePlan,
                    Precio = p.Precio,
                    Coste = p.Coste,
                    Descripcion = p.Descripcion,
                    Beneficios = p.Beneficios,
                    IsActive = p.IsActive
                })
                .ToListAsync(cancellationToken);

            return Result<List<TipoPlanDto>>.Success(200, planes, "Planes obtenidos correctamente", true);
        }
    }
}
