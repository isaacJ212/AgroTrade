using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Productos.Commands
{
    public record CreateProductoCommand(
        int IdCategoria,
        int IdProveedor,
        int IdUnidadMedida,
        string Nombre,
        string? Descripcion) : IRequest<Result<int>>;

    public class CreateProductoCommandHandler : IRequestHandler<CreateProductoCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public CreateProductoCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateProductoCommand request, CancellationToken cancellationToken)
        {
            var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == request.IdCategoria, cancellationToken);
            if (!categoriaExiste)
                return Result<int>.Failure(404, "La categoría especificada no existe.");

            var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.IdProveedor, cancellationToken);
            if (!proveedorExiste)
                return Result<int>.Failure(404, "El proveedor especificado no existe.");

            var unidadExiste = await _unitOfWork.UnidadesDeMedida.AnyAsync(u => u.Id == request.IdUnidadMedida, cancellationToken);
            if (!unidadExiste)
                return Result<int>.Failure(404, "La unidad de medida especificada no existe.");

            var producto = new Producto
            {
                IdCategoria = request.IdCategoria,
                IdProveedor = request.IdProveedor,
                IdUnidadDeMedida = request.IdUnidadMedida,
                Nombre = request.Nombre,
                Descripcion = request.Descripcion
            };

            await _unitOfWork.Productos.AddAsync(producto, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Success(201, producto.IdProducto, "Producto creado correctamente.", true);
        }
    }
}
