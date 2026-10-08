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
        private readonly IEmailService _emailService;

        public CreateSuscripcionCommandHandler(IUnitofWork unitOfWork, IEmailService emailService)
        {
            _unitOfWork = unitOfWork;
            _emailService = emailService;
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
                IdPlan = request.Dto.IdPlan,
                TarifaPago = request.Dto.TarifaPago,
                Estado = "Activa",
                FechaInicio = DateTime.UtcNow,
                FechaFin = DateTime.UtcNow.AddMonths(request.Dto.MesesDuracion),
                RenovacionAutomatica = true,
                CreadaEn = DateTime.UtcNow
            };

            await _unitOfWork.Suscripciones.AddAsync(nuevaSuscripcion, ct);
            await _unitOfWork.SaveChangesAsync(ct);

            // Enviar correo de confirmación de suscripción de forma asíncrona pero sin esperar si no es necesario o esperándolo si queremos asegurar.
            // Para asegurar que llegue, usamos await.
            try
            {
                await _emailService.SendSubscriptionReceiptAsync(usuario.Email, request.Dto.TipoPlan, request.Dto.TarifaPago.ToString("F2"), ct);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al intentar enviar el correo de suscripción: {ex.Message}");
            }

            return Result<int>.Success(201, nuevaSuscripcion.IdSuscripcionApp, "Suscripción activada con éxito.", true);
        }
        
    }
}