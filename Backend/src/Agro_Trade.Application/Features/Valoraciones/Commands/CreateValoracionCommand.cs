using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Valoraciones.Commands
{
    public record CreateValoracionCommand(
        int IdPedido, 
        int IdProveedor, 
        string? TipoValoracion, 
        int Puntuacion, 
        string? Comentario,
        int IdUsuarioCliente
    ) : IRequest<Result<int>>;

    public class CreateValoracionCommandHandler : IRequestHandler<CreateValoracionCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public CreateValoracionCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateValoracionCommand request, CancellationToken cancellationToken)
        {
            // Validar que el pedido exista y pertenezca al usuario
            var pedido = await _unitOfWork.Pedidos.GetByIdAsync(request.IdPedido, cancellationToken);
            if (pedido == null)
            {
                return Result<int>.Failure(404, "El pedido especificado no existe.");
            }

            if (pedido.IdUsuarioCliente != request.IdUsuarioCliente)
            {
                return Result<int>.Failure(403, "No tienes permiso para valorar este pedido.");
            }

            // Validar que el proveedor exista
            var proveedor = await _unitOfWork.Proveedores.GetByIdAsync(request.IdProveedor, cancellationToken);
            if (proveedor == null)
            {
                return Result<int>.Failure(404, "El proveedor especificado no existe.");
            }

            // Validar que no exista una valoración para este pedido y usuario
            var valoracionExistente = await _unitOfWork.Valoraciones.AnyAsync(
                v => v.IdPedido == request.IdPedido && v.IdUsuarioCliente == request.IdUsuarioCliente,
                cancellationToken);
            if (valoracionExistente)
            {
                return Result<int>.Failure(400, "Ya has valorado este pedido.");
            }

            var valoracion = new Valoracion
            {
                IdPedido = request.IdPedido,
                IdUsuarioCliente = request.IdUsuarioCliente,
                IdProveedor = request.IdProveedor,
                TipoValoracion = request.TipoValoracion,
                Puntuacion = request.Puntuacion,
                Comentario = request.Comentario,
                FechaValoracion = DateTime.UtcNow
            };

            await _unitOfWork.Valoraciones.AddAsync(valoracion, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            // Actualizar el promedio de calificación del proveedor
            await ActualizarPromedioProveedor(request.IdProveedor, cancellationToken);

            return Result<int>.Success(201, valoracion.IdValoracion, "Valoración creada correctamente.", true);
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
