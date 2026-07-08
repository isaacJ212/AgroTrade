using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.CategoriasDtos;
using Meseta_Verde.Application.Common.Interface;
using Microsoft.EntityFrameworkCore;

namespace Meseta_Verde.Application.Features.Categorias.Queries
{
    public record GetCategoriasQuery : IRequest<Result<List<CategoriaDto>>>;

    public class GetCategoriasQueryHandler : IRequestHandler<GetCategoriasQuery, Result<List<CategoriaDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetCategoriasQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<CategoriaDto>>> Handle(GetCategoriasQuery request, CancellationToken cancellationToken)
        {
            var categorias = await _unitOfWork.Categorias.GetAllAsync(cancellationToken);
            if(categorias == null || !categorias.Any())
                return Result<List<CategoriaDto>>.Failure(200, "No se encontraron categorías.");
            var data = categorias.Select(c => new CategoriaDto { IdCategoria = c.IdCategoria, Nombre = c.Nombre }).ToList();

            return Result<List<CategoriaDto>>.Succes(200, data, "Categorías obtenidas correctamente.", true);
        }
    }
}