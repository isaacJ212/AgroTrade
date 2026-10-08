using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Productos.Commands
{
    public record UpdateProductoCommand(
        int IdProducto,
        int IdCategoria,
        int IdProveedor,
        int IdUnidadMedida,
        string Nombre,
        string? Descripcion) : IRequest<Result<bool>>;

    public class UpdateProductoCommandHandler : IRequestHandler<UpdateProductoCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public UpdateProductoCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(UpdateProductoCommand request, CancellationToken cancellationToken)
        {
            if (request.IdProducto <= 0)
                return Result<bool>.Failure(400, "El ID del producto es inválido.");

            var producto = await _unitOfWork.Productos.GetByIdAsync(request.IdProducto, cancellationToken);
            if (producto is null)
                return Result<bool>.Failure(404, "No se encontró el producto.");

            var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == request.IdCategoria, cancellationToken);
            if (!categoriaExiste)
                return Result<bool>.Failure(404, "La categoría especificada no existe.");

            var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.IdProveedor, cancellationToken);
            if (!proveedorExiste)
                return Result<bool>.Failure(404, "El proveedor especificado no existe.");

            var unidadExiste = await _unitOfWork.UnidadesDeMedida.AnyAsync(u => u.Id == request.IdUnidadMedida, cancellationToken);
            if (!unidadExiste)
                return Result<bool>.Failure(404, "La unidad de medida especificada no existe.");

            producto.IdCategoria = request.IdCategoria;
            producto.IdProveedor = request.IdProveedor;
            producto.IdUnidadDeMedida = request.IdUnidadMedida;
            producto.Nombre = request.Nombre;
            producto.Descripcion = request.Descripcion;

            await _unitOfWork.Productos.UpdateAsync(producto, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Producto actualizado correctamente.", true);
        }
    }
}
