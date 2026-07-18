using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;


namespace Meseta_Verde.Application.Features.Suscripciones.Commands
{
    public record CancelSuscripcionCommand(int IdSuscripcion) : IRequest<Result<bool>>;

    public class CancelSuscripcionCommandHandler : IRequestHandler<CancelSuscripcionCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public CancelSuscripcionCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(CancelSuscripcionCommand request, CancellationToken ct)
        {
            var suscripcion = await _unitOfWork.Suscripciones.GetByIdAsync(request.IdSuscripcion, ct);
            
            if (suscripcion == null)
                return Result<bool>.Failure(404, "Suscripción no encontrada.");

            if (suscripcion.Estado == "Cancelada")
                return Result<bool>.Failure(400, "Esta suscripción ya se encuentra cancelada.");

            suscripcion.Estado = "Cancelada";
            suscripcion.RenovacionAutomatica = false;

            await _unitOfWork.Suscripciones.UpdateAsync(suscripcion, ct);
            await _unitOfWork.SaveChangesAsync(ct);

            return Result<bool>.Success(200, true, "Suscripción cancelada correctamente.", true);
        }


        
    }
}