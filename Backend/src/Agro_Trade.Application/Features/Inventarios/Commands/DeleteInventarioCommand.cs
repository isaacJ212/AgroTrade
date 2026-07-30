using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;



namespace Agro_Trade.Application.Features.Inventarios.Commands
{
    public record DeleteInventarioCommand(int IdInventario) : IRequest<Result<bool>>;


    public class DeleteInventarioCommandHandler : IRequestHandler<DeleteInventarioCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public DeleteInventarioCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }


        public async Task<Result<bool>> Handle(DeleteInventarioCommand request, CancellationToken cancellationToken)
        {
            // 1. Validar que el ID sea correcto
            if (request.IdInventario <= 0)
                return Result<bool>.Failure(400, "El ID del inventario es inválido.");

            // 2. Buscar el registro en la base de datos
            var inventario = await _unitOfWork.InventarioProveedor.GetByIdAsync(request.IdInventario, cancellationToken);
            
            if (inventario is null)
                return Result<bool>.Failure(404, "No se encontró el registro de inventario.");

            // Opcional: Validar si ya estaba desactivado para no gastar recursos
            if (!inventario.Disponible)
                return Result<bool>.Failure(400, "Este inventario ya se encontraba dado de baja.");

            // 3. APLICAR SOFT DELETE (Borrado Lógico)
            inventario.Disponible = false;

            // Fíjate que usamos UpdateAsync y NO DeleteAsync
            await _unitOfWork.InventarioProveedor.UpdateAsync(inventario, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Inventario dado de baja (desactivado) exitosamente.", true);
            
        }
    }
}