using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Valoraciones.Commands
{
    public record DeleteValoracionCommand(int IdValoracion, int IdUsuarioCliente) : IRequest<Result<bool>>;

    public class DeleteValoracionCommandHandler : IRequestHandler<DeleteValoracionCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public DeleteValoracionCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(DeleteValoracionCommand request, CancellationToken cancellationToken)
        {
            var valoracion = await _unitOfWork.Valoraciones.GetByIdAsync(request.IdValoracion, cancellationToken);
            if (valoracion == null)
            {
                return Result<bool>.Failure(404, "La valoración especificada no existe.");
            }

            if (valoracion.IdUsuarioCliente != request.IdUsuarioCliente)
            {
                return Result<bool>.Failure(403, "No tienes permiso para eliminar esta valoración.");
            }

            var idProveedor = valoracion.IdProveedor;
            await _unitOfWork.Valoraciones.DeleteAsync(valoracion, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            // Actualizar el promedio del proveedor
            await ActualizarPromedioProveedor(idProveedor, cancellationToken);

            return Result<bool>.Success(200, true, "Valoración eliminada correctamente.", true);
        }

        private async Task ActualizarPromedioProveedor(int idProveedor, CancellationToken cancellationToken)
        {
            var valoraciones = await _unitOfWork.Valoraciones.FindAsync(v => v.IdProveedor == idProveedor, cancellationToken);
            var proveedor = await _unitOfWork.Proveedores.GetByIdAsync(idProveedor, cancellationToken);

            if (proveedor != null)
            {
                if (valoraciones.Any())
                {
                    var promedio = valoraciones.Average(v => v.Puntuacion);
                    proveedor.CalificacionPromedio = (float)promedio;
                }
                else
                {
                    proveedor.CalificacionPromedio = null;
                }

                await _unitOfWork.Proveedores.UpdateAsync(proveedor, cancellationToken);
                await _unitOfWork.SaveChangesAsync(cancellationToken);
            }
        }
    }
}
