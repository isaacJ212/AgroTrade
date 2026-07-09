using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ProductosDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Productos.Queries
{
    public record GetProductosQuery : IRequest<Result<List<ProductoDto>>>;

    public class GetProductosQueryHandler : IRequestHandler<GetProductosQuery, Result<List<ProductoDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetProductosQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<ProductoDto>>> Handle(GetProductosQuery request, CancellationToken cancellationToken)
        {
            var productos = await _unitOfWork.Productos.GetAllAsync(cancellationToken);
            if (productos == null || !productos.Any())
                return Result<List<ProductoDto>>.Failure(200, "No se encontraron productos.");
            var data = productos.Select(p => new ProductoDto
            {
                IdProducto = p.IdProducto,
                IdCategoria = p.IdCategoria,
                IdProveedor = p.IdProveedor,
                Nombre = p.Nombre,
                Descripcion = p.Descripcion,
                UnidadMedida = p.UnidadMedida
               
            }).ToList();

            return Result<List<ProductoDto>>.Succes(200, data, "Productos obtenidos correctamente.", true);
        }
    }
}