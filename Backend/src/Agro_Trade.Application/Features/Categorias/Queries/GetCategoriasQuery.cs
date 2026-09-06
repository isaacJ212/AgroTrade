using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.CategoriasDtos;
using Agro_Trade.Application.Common.Interface;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Categorias.Queries
{
    public class GetCategoriasQuery : IRequest<Result<PagedResponse<CategoriaDto>>>
    {
        public int PageIndex { get; set; } = 1;
        public int PageSize { get; set; } = 50;
        public bool HasProducts { get; set; } = false;
    }

    public class GetCategoriasQueryHandler : IRequestHandler<GetCategoriasQuery, Result<PagedResponse<CategoriaDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetCategoriasQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<PagedResponse<CategoriaDto>>> Handle(GetCategoriasQuery request, CancellationToken cancellationToken)
        {
            var query = _unitOfWork.Categorias.GetQueryable();

            if (request.HasProducts)
            {
                query = query.Where(c => c.Productos.Any());
            }

            var totalCount = await query.CountAsync(cancellationToken);
            
            var categorias = await query
                .Skip((request.PageIndex - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync(cancellationToken);

            var data = categorias.Select(c => new CategoriaDto { IdCategoria = c.IdCategoria, Nombre = c.Nombre }).ToList();
            
            var pagedData = PagedResponse<CategoriaDto>.ToPagedResponse(data, request.PageIndex, request.PageSize, totalCount);
            return Result<PagedResponse<CategoriaDto>>.Success(200, pagedData, "Categorías obtenidas correctamente.", true);
        }
    }
}