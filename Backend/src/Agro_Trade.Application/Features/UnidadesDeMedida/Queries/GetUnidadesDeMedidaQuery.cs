using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.UnidadesDeMedidaDtos;
using Agro_Trade.Application.Common.Interface;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.UnidadesDeMedida.Queries
{
    public record GetUnidadesDeMedidaQuery : IRequest<Result<List<UnidadDeMedidaDto>>>;

    public class GetUnidadesDeMedidaQueryHandler : IRequestHandler<GetUnidadesDeMedidaQuery, Result<List<UnidadDeMedidaDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetUnidadesDeMedidaQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<UnidadDeMedidaDto>>> Handle(GetUnidadesDeMedidaQuery request, CancellationToken cancellationToken)
        {
            var unidades = await _unitOfWork.UnidadesDeMedida
                .GetQueryable()
                .OrderBy(u => u.Nombre)
                .Select(u => new UnidadDeMedidaDto
                {
                    Id     = u.Id,
                    Nombre = u.Nombre,
                    Codigo = u.Codigo,
                    Factor = u.Factor,
                    IdBase = u.IdBase
                })
                .ToListAsync(cancellationToken);

            return Result<List<UnidadDeMedidaDto>>.Success(200, unidades, "Unidades de medida obtenidas correctamente.", true);
        }
    }
}
