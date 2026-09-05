using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProductosDtos;
using Agro_Trade.Application.Common.Interface;

using Agro_Trade.Application.Common.DTOs;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Productos.Queries
{
    public record GetProductosQuery(int Page = 1, int Limit = 20, string? Search = null) : IRequest<Result<PaginatedResultDto<ProductoDto>>>;

    public class GetProductosQueryHandler : IRequestHandler<GetProductosQuery, Result<PaginatedResultDto<ProductoDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetProductosQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<PaginatedResultDto<ProductoDto>>> Handle(GetProductosQuery request, CancellationToken cancellationToken)
        {
            var query = _unitOfWork.Productos.GetQueryable()
                .Include(p => p.Categoria)
                .Include(p => p.Inventarios)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(request.Search))
            {
                var lowerSearch = request.Search.ToLower();
                query = query.Where(p => p.Nombre.ToLower().Contains(lowerSearch));
            }
            
            var totalItems = await query.CountAsync(cancellationToken);
            var totalPages = (int)Math.Ceiling(totalItems / (double)request.Limit);

            var productos = await query
                .Skip((request.Page - 1) * request.Limit)
                .Take(request.Limit)
                .ToListAsync(cancellationToken);

            var data = productos.Select(p => 
            {
                var inventario = p.Inventarios.FirstOrDefault(i => i.Disponible);
                return new ProductoDto
                {
                    IdProducto = p.IdProducto,
                    IdCategoria = p.IdCategoria,
                    CategoriaNombre = p.Categoria?.Nombre,
                    IdProveedor = p.IdProveedor,
                    Nombre = p.Nombre,
                    Descripcion = p.Descripcion,
                    UnidadMedida = p.UnidadMedida,
                    Precio = inventario?.PrecioVenta ?? 0,
                    FotoUrl = inventario?.FotoUrl
                };
            }).ToList();

            var paginatedResult = new PaginatedResultDto<ProductoDto>
            {
                TotalItems = totalItems,
                TotalPages = totalPages,
                CurrentPage = request.Page,
                Items = data
            };

            return Result<PaginatedResultDto<ProductoDto>>.Success(200, paginatedResult, "Productos obtenidos correctamente.", true);
        }
    }
}