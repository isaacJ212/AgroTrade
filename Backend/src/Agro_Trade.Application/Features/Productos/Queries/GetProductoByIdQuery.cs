using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProductosDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Productos.Queries
{
    public record GetProductoByIdQuery(int IdProducto) : IRequest<Result<ProductoDto?>>;

    public class GetProductoByIdQueryHandler : IRequestHandler<GetProductoByIdQuery, Result<ProductoDto?>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetProductoByIdQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<ProductoDto?>> Handle(GetProductoByIdQuery request, CancellationToken cancellationToken)
        {
            var producto = await _unitOfWork.Productos.GetByIdAsync(request.IdProducto, cancellationToken);
            if (producto is null)
            {
                return Result<ProductoDto?>.Failure(404, "No se encontró el producto.");
            }

            var data = new ProductoDto 
            { 
                IdProducto = producto.IdProducto,
                IdCategoria = producto.IdCategoria,
                IdProveedor = producto.IdProveedor,
                Nombre = producto.Nombre,
                Descripcion = producto.Descripcion,
                UnidadMedida = producto.UnidadMedida
            };
            return Result<ProductoDto?>.Success(200, data, "Producto obtenido correctamente.", true);
        }
    }
}
