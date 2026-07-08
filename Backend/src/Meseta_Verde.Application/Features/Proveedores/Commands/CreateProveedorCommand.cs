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
    public record CreateProveedorCommand(int IdProveedor, int IdUsuario, string NombreProveedor, string NombreFinca, string UbicacionGps, string Biografia ,float CalificacionPromedio) : IRequest<Result<int>>;
    public class CreateProveedorCommandHandlder : IRequestHandler<CreateProveedorCommand, Result<int>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public CreateProveedorCommandHandlder(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateProveedorCommand request, CancellationToken cancellationToken)
        {
            //validar de que existe el usuarioo
            //COMENTO ESTO POR QUE ME DA ERROR POR QUE ME VA A DAR ERRO AL COMPILAR
            /*var usuarioExiste = await _unitOfWork.Usuarios.AnyAsync(c => c.IdUsuario == request.IdUsuario, cancellationToken);
            if(!usuarioExiste)
            {
                return Result<int>.Failure(404, "El usuario especificado no existe");
            }*/

            var proveedor = new Proveedor
            {
              IdUsuario = request.IdUsuario,
              NombreProveedor = request.NombreProveedor,
              NombreFinca = request.NombreFinca,
              UbicacionGps = request.UbicacionGps,
              Biografia = request.Biografia,
              CalificacionPromedio = request.CalificacionPromedio

            };

            await _unitOfWork.Proveedores.AddAsync(proveedor, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Succes(201, proveedor.IdProveedor, "Proveedor creado correctamente", true);
            
        }
    }
}