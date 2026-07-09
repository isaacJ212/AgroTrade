using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;

namespace Meseta_Verde.Application.Features.Proveedores.Commands
{
    public record CreateProveedorCommand(int IdUsuario, string NombreProveedor, string? NombreFinca, string? UbicacionGps, string? Biografia) : IRequest<Result<int>>;
    public class CreateProveedorCommandHandler : IRequestHandler<CreateProveedorCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public CreateProveedorCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateProveedorCommand request, CancellationToken cancellationToken)
        {
            // Validar que el usuario exista
            var usuarioExiste = await _unitOfWork.Usuarios.AnyAsync(c => c.IdUsuario == request.IdUsuario, cancellationToken);
            if (!usuarioExiste)
            {
                return Result<int>.Failure(404, "El usuario especificado no existe");
            }

            // Validar que el nombre del proveedor no esté vacío
            if (string.IsNullOrWhiteSpace(request.NombreProveedor))
            {
                return Result<int>.Failure(400, "El nombre del proveedor es obligatorio.");
            }

            var proveedor = new Proveedor
            {
                IdUsuario = request.IdUsuario,
                NombreProveedor = request.NombreProveedor,
                NombreFinca = request.NombreFinca,
                UbicacionGps = request.UbicacionGps,
                Biografia = request.Biografia,
                CalificacionPromedio = null
            };

            await _unitOfWork.Proveedores.AddAsync(proveedor, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Succes(201, proveedor.IdProveedor, "Proveedor creado correctamente", true);

        }
    }
}