using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.SuscripcionesDtos;
using Agro_Trade.Application.Common.Interface;



namespace Agro_Trade.Application.Features.Suscripciones.Commands
{
    public record CreateSuscripcionCommand(CreateSuscripcionDto Dto) : IRequest<Result<int>>;

    public class CreateSuscripcionCommandHandler : IRequestHandler<CreateSuscripcionCommand, Result<int>>
    {

        private readonly IUnitofWork _unitOfWork;

        public CreateSuscripcionCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateSuscripcionCommand request, CancellationToken ct)
        {
            // Validar que el usuario exista
            var usuario = await _unitOfWork.Users.GetByIdAsync(request.Dto.IdUsuario, ct);
            if (usuario == null)
                return Result<int>.Failure(404, "El usuario no existe.");

            // Validar que no tenga una suscripción activa
            var suscripcionActiva = await _unitOfWork.Suscripciones.AnyAsync(
                s => s.IdUsuario == request.Dto.IdUsuario && s.Estado == "Activa", ct);

            if (suscripcionActiva)
                return Result<int>.Failure(400, "El usuario ya posee una suscripción activa.");

            var nuevaSuscripcion = new SuscripcionApp
            {
                IdUsuario = request.Dto.IdUsuario,
                TipoPlan = request.Dto.TipoPlan,
                TarifaPago = request.Dto.TarifaPago,
                Estado = "Activa",
                FechaInicio = DateTime.UtcNow,
                FechaFin = DateTime.UtcNow.AddMonths(request.Dto.MesesDuracion),
                RenovacionAutomatica = true,
                CreadaEn = DateTime.UtcNow
            };

            await _unitOfWork.Suscripciones.AddAsync(nuevaSuscripcion, ct);
            await _unitOfWork.SaveChangesAsync(ct);

            return Result<int>.Success(201, nuevaSuscripcion.IdSuscripcionApp, "Suscripción activada con éxito.", true);
        }
        
    }
}