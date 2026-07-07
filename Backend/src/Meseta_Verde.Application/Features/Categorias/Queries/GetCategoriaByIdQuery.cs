using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.CategoriasDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Categorias.Queries
{
    public record GetCategoriaByIdQuery(int IdCategoria) : IRequest<Result<CategoriaDto?>>;

    public class GetCategoriaByIdQueryHandler : IRequestHandler<GetCategoriaByIdQuery, Result<CategoriaDto?>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public GetCategoriaByIdQueryHandler(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<CategoriaDto?>> Handle(GetCategoriaByIdQuery request, CancellationToken cancellationToken)
        {
            var categoria = await _unitOfWork.Categorias.GetByIdAsync(request.IdCategoria, cancellationToken);
            if (categoria is null)
            {
                return Result<CategoriaDto?>.Failure(404, "No se encontró la categoría.");
            }

            var data = new CategoriaDto { IdCategoria = categoria.IdCategoria, Nombre = categoria.Nombre };
            return Result<CategoriaDto?>.Succes(200, data, "Categoría obtenida correctamente.", true);
        }
    }
}