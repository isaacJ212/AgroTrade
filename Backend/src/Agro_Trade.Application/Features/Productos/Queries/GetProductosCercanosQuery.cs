using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProductosDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Common.DTOs;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Productos.Queries
{
    public record GetProductosCercanosQuery(int Limit = 10) : IRequest<Result<List<ProductoDto>>>;

    public class GetProductosCercanosQueryHandler : IRequestHandler<GetProductosCercanosQuery, Result<List<ProductoDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetProductosCercanosQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<ProductoDto>>> Handle(GetProductosCercanosQuery request, CancellationToken cancellationToken)
        {
            var query = _unitOfWork.Productos.GetQueryable()
                .Include(p => p.Categoria)
                .Include(p => p.Inventarios)
                .Where(p => p.Inventarios.Any(i => i.Disponible))
                .OrderByDescending(p => p.IdProducto) // Simulación de "Cercanos"
                .AsQueryable();

            var productos = await query
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

            return Result<List<ProductoDto>>.Success(200, data, "Productos cercanos obtenidos correctamente.", true);
        }
    }
}
