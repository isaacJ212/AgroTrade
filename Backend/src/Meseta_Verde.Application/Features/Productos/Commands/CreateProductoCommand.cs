using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;

namespace Meseta_Verde.Application.Features.Productos.Commands
{
    public record CreateProductoCommand(int IdCategoria, int IdProveedor, string Nombre, string? Descripcion, string UnidadMedida) : IRequest<Result<int>>;

    public class CreateProductoCommandHandler : IRequestHandler<CreateProductoCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public CreateProductoCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateProductoCommand request, CancellationToken cancellationToken)
        {
            // Validar que la categoría exista
            var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == request.IdCategoria, cancellationToken);
            if (!categoriaExiste)
            {
                return Result<int>.Failure(404, "La categoría especificada no existe.");
            }

            // Validar que el proveedor exista
            var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.IdProveedor, cancellationToken);
            if (!proveedorExiste)
            {
                return Result<int>.Failure(404, "El proveedor especificado no existe.");
            }
            
            var producto = new Producto
            {
                IdCategoria = request.IdCategoria,
                IdProveedor = request.IdProveedor,
                Nombre = request.Nombre,
                Descripcion = request.Descripcion,
                UnidadMedida = request.UnidadMedida
            };
            
            await _unitOfWork.Productos.AddAsync(producto, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Succes(201, producto.IdProducto, "Producto creado correctamente.", true);
        }
    }
}
