
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Proveedores.Commands
{
    public record UpdateProveedorCommand(int IdProveedor, int IdUsuario, string NombreProveedor, string? NombreFinca, string? UbicacionGps, string? Biografia, float? CalificacionPromedio) : IRequest<Result<bool>>;

    public class UpdateProveedorCommandHandler : IRequestHandler<UpdateProveedorCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public UpdateProveedorCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(UpdateProveedorCommand request, CancellationToken cancellationToken)
        {
            if (request.IdProveedor <= 0)
            {
                return Result<bool>.Failure(400, "El ID del proveedor es inválido.");
            }

            // Validar que el usuario exista
            var usuarioExiste = await _unitOfWork.Usuarios.AnyAsync(c => c.IdUsuario == request.IdUsuario, cancellationToken);
            if (!usuarioExiste)
            {
                return Result<bool>.Failure(404, "El usuario especificado no existe");
            }

            // Validar que el nombre del proveedor no esté vacío
            if (string.IsNullOrWhiteSpace(request.NombreProveedor))
            {
                return Result<bool>.Failure(400, "El nombre del proveedor es obligatorio.");
            }

            var proveedor = await _unitOfWork.Proveedores.GetByIdAsync(request.IdProveedor, cancellationToken);
            if (proveedor is null)
            {
                return Result<bool>.Failure(404, "No se encontró el proveedor.");
            }

            proveedor.IdUsuario = request.IdUsuario;
            proveedor.NombreProveedor = request.NombreProveedor;
            proveedor.NombreFinca = request.NombreFinca;
            proveedor.UbicacionGps = request.UbicacionGps;
            proveedor.Biografia = request.Biografia;
            proveedor.CalificacionPromedio = request.CalificacionPromedio;

            await _unitOfWork.Proveedores.UpdateAsync(proveedor, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Proveedor actualizado correctamente.", true);
        }
    }
}
