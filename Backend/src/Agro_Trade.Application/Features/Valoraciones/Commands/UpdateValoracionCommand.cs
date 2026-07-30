using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Valoraciones.Commands
{
    public record UpdateValoracionCommand(
        int IdValoracion,
        int? Puntuacion,
        string? Comentario,
        int IdUsuarioCliente
    ) : IRequest<Result<bool>>;

    public class UpdateValoracionCommandHandler : IRequestHandler<UpdateValoracionCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public UpdateValoracionCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(UpdateValoracionCommand request, CancellationToken cancellationToken)
        {
            var valoracion = await _unitOfWork.Valoraciones.GetByIdAsync(request.IdValoracion, cancellationToken);
            if (valoracion == null)
            {
                return Result<bool>.Failure(404, "La valoración especificada no existe.");
            }

            if (valoracion.IdUsuarioCliente != request.IdUsuarioCliente)
            {
                return Result<bool>.Failure(403, "No tienes permiso para modificar esta valoración.");
            }

            if (request.Puntuacion.HasValue)
                valoracion.Puntuacion = request.Puntuacion.Value;
            
            if (request.Comentario != null)
                valoracion.Comentario = request.Comentario;

            await _unitOfWork.Valoraciones.UpdateAsync(valoracion, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            // Actualizar el promedio del proveedor
            await ActualizarPromedioProveedor(valoracion.IdProveedor, cancellationToken);

            return Result<bool>.Success(200, true, "Valoración actualizada correctamente.", true);
        }

        private async Task ActualizarPromedioProveedor(int idProveedor, CancellationToken cancellationToken)
        {
            var valoraciones = await _unitOfWork.Valoraciones.FindAsync(v => v.IdProveedor == idProveedor, cancellationToken);
            if (valoraciones.Any())
            {
                var promedio = valoraciones.Average(v => v.Puntuacion);
                var proveedor = await _unitOfWork.Proveedores.GetByIdAsync(idProveedor, cancellationToken);
                if (proveedor != null)
                {
                    proveedor.CalificacionPromedio = (float)promedio;
                    await _unitOfWork.Proveedores.UpdateAsync(proveedor, cancellationToken);
                    await _unitOfWork.SaveChangesAsync(cancellationToken);
                }
            }
        }
    }
}
