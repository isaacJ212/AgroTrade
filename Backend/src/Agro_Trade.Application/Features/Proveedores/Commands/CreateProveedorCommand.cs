using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Proveedores.Commands
{
    public record CreateProveedorCommand(int IdUsuario, string NombreProveedor, string? NombreFinca, string? UbicacionGps, string? Biografia, int IdCuentaBancaria) : IRequest<Result<int>>;
    public class CreateProveedorCommandHandler : IRequestHandler<CreateProveedorCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IRepository<CuentaBancaria> _cuentasBancarias;

        public CreateProveedorCommandHandler(IUnitofWork unitOfWork, IRepository<CuentaBancaria> cuentasBancarias)
        {
            _unitOfWork = unitOfWork;
            _cuentasBancarias = cuentasBancarias;
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

            if (request.IdCuentaBancaria <= 0)
            {
                return Result<int>.Failure(400, "Debe seleccionar una cuenta bancaria válida.");
            }

            var cuentaBancaria = await _cuentasBancarias.FirstOrDefaultAsync(
                cuenta => cuenta.IdCuenta == request.IdCuentaBancaria
                          && cuenta.IdUsuario == request.IdUsuario
                          && cuenta.isActive,
                cancellationToken);
            if (cuentaBancaria is null)
            {
                return Result<int>.Failure(400, "La cuenta bancaria no existe, no está activa o no pertenece al usuario.");
            }

            var proveedor = new Proveedor
            {
                IdUsuario = request.IdUsuario,
                NombreProveedor = request.NombreProveedor,
                NombreFinca = request.NombreFinca,
                UbicacionGps = request.UbicacionGps,
                Biografia = request.Biografia,
                CalificacionPromedio = null,
                IdCuentaBancaria = cuentaBancaria.IdCuenta
                
            };

            await _unitOfWork.Proveedores.AddAsync(proveedor, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Success(201, proveedor.IdProveedor, "Proveedor creado correctamente", true);

        }
    }
}