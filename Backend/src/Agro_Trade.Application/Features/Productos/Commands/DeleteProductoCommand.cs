using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Productos.Commands
{
    public record DeleteProductoCommand(int IdProducto) : IRequest<Result<bool>>;

    public class DeleteProductoCommandHandler : IRequestHandler<DeleteProductoCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public DeleteProductoCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(DeleteProductoCommand request, CancellationToken cancellationToken)
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

            // Si quieres validar que no tenga registros asociados (como inventario, pedidos, etc.), puedes hacerlo aquí
            // Por ahora solo eliminamos el producto

            await _unitOfWork.Productos.DeleteAsync(producto, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Producto eliminado correctamente.", true);
        }
    }
}
