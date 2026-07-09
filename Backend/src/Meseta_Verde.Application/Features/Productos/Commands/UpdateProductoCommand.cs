using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Productos.Commands
{
    public record UpdateProductoCommand(int IdProducto, int IdCategoria, int IdProveedor, string Nombre, string? Descripcion, string UnidadMedida) : IRequest<Result<bool>>;

    public class UpdateProductoCommandHandler : IRequestHandler<UpdateProductoCommand, Result<bool>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public UpdateProductoCommandHandler(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(UpdateProductoCommand request, CancellationToken cancellationToken)
        {
            if (request.IdProducto <= 0)
            {
                return Result<bool>.Failure(400, "El ID del producto es inválido.");
            }

            var producto = await _unitOfWork.Productos.GetByIdAsync(request.IdProducto, cancellationToken);
            if (producto is null)
            {
                return Result<bool>.Failure(404, "No se encontró el producto.");
            }

            // Validar que la categoría exista
            var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == request.IdCategoria, cancellationToken);
            if (!categoriaExiste)
            {
                return Result<bool>.Failure(404, "La categoría especificada no existe.");
            }

            // Validar que el proveedor exista
            var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.IdProveedor, cancellationToken);
            if (!proveedorExiste)
            {
                return Result<bool>.Failure(404, "El proveedor especificado no existe.");
            }

            producto.IdCategoria = request.IdCategoria;
            producto.IdProveedor = request.IdProveedor;
            producto.Nombre = request.Nombre;
            producto.Descripcion = request.Descripcion;
            producto.UnidadMedida = request.UnidadMedida;

            await _unitOfWork.Productos.UpdateAsync(producto, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Succes(200, true, "Producto actualizado correctamente.", true);
        }
    }
}
