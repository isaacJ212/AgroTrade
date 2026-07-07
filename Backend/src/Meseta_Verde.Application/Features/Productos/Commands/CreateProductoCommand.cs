using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;

namespace Meseta_Verde.Application.Features.Productos.Commands
{
    public record CreateProductoCommand(int IdCategoria, int IdProveedor, string Nombre, string? Descripcion, string UnidadMedida) : IRequest<Result<int>>;

    public class CreateProductoCommandHandler : IRequestHandler<CreateProductoCommand, Result<int>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public CreateProductoCommandHandler(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateProductoCommand request, CancellationToken cancellationToken)
        {
            var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == request.IdCategoria, cancellationToken);
            if (!categoriaExiste)
            {
                return Result<int>.Failure(404, "La categoría especificada no existe.");
            }

            var proveedorExiste = await _unitOfWork.Productos.AnyAsync(p => p.IdProveedor == request.IdProveedor, cancellationToken) || true; // TODO: Verificar proveedor cuando tengamos el repositorio
            
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
