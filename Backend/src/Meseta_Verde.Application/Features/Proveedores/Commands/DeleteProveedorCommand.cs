
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Proveedores.Commands
{
    public record DeleteProveedorCommand(int IdProveedor) : IRequest<Result<bool>>;

    public class DeleteProveedorCommandHandler : IRequestHandler<DeleteProveedorCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public DeleteProveedorCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(DeleteProveedorCommand request, CancellationToken cancellationToken)
        {
            if (request.IdProveedor <= 0)
            {
                return Result<bool>.Failure(400, "El ID del proveedor es inválido.");
            }

            var proveedor = await _unitOfWork.Proveedores.FirstOrDefaultAsync(
                p => p.IdProveedor == request.IdProveedor,
                cancellationToken,
                p => p.Productos);

            if (proveedor is null)
            {
                return Result<bool>.Failure(404, "No se encontró el proveedor.");
            }

            if (proveedor.Productos.Any())
            {
                return Result<bool>.Failure(400, "No se puede eliminar el proveedor porque tiene productos asociados.");
            }

            await _unitOfWork.Proveedores.DeleteAsync(proveedor, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Proveedor eliminado correctamente.", true);
        }
    }
}
