using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProductosDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Common.DTOs;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Productos.Queries
{
    public record GetProductosOfertasQuery(int Limit = 5) : IRequest<Result<List<ProductoDto>>>;

    public class GetProductosOfertasQueryHandler : IRequestHandler<GetProductosOfertasQuery, Result<List<ProductoDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetProductosOfertasQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<ProductoDto>>> Handle(GetProductosOfertasQuery request, CancellationToken cancellationToken)
        {
            var query = _unitOfWork.Productos.GetQueryable()
                .Include(p => p.Categoria)
                .Include(p => p.Inventarios)
                .Where(p => p.Inventarios.Any(i => i.Disponible && i.EsOfertaExcedente))
                .AsQueryable();

            var productos = await query
                .Take(request.Limit)
                .ToListAsync(cancellationToken);

            var data = productos.Select(p => 
            {
                var inventario = p.Inventarios.FirstOrDefault(i => i.Disponible && i.EsOfertaExcedente) ?? p.Inventarios.FirstOrDefault();
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

            return Result<List<ProductoDto>>.Success(200, data, "Ofertas obtenidas correctamente.", true);
        }
    }
}
