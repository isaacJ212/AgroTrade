using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ConversacionesDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Conversaciones.Commands
{
    public record SendMessageCommand(SendMessageDto Dto) : IRequest<Result<MensajeDto>>;


    public class SendMessageCommandHandler : IRequestHandler<SendMessageCommand, Result<MensajeDto>>
    {
        private readonly IUnitofWork _unitOfWork;

        public SendMessageCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<MensajeDto>> Handle(SendMessageCommand request, CancellationToken ct)
        {
            var conversacion = await _unitOfWork.Conversaciones.GetByIdAsync(request.Dto.IdConversacion, ct);
            if (conversacion == null)
                return Result<MensajeDto>.Failure(404, "La conversación no existe.");

            var nuevoMensaje = new Mensaje
            {
                IdConversacion = request.Dto.IdConversacion,
                IdUsuarioEmisor = request.Dto.IdUsuarioEmisor,
                Contenido = request.Dto.Contenido,
                EnviadoEn = DateTime.UtcNow,
                Leido = false
            };

            await _unitOfWork.Mensajes.AddAsync(nuevoMensaje, ct);
            await _unitOfWork.SaveChangesAsync(ct);

            // Fetch user to get name
            var emisor = await _unitOfWork.Usuarios.GetByIdAsync(request.Dto.IdUsuarioEmisor, ct);
            var nombreEmisor = emisor != null ? $"{emisor.Nombre} {emisor.PrimerApellido}".Trim() : $"Usuario #{request.Dto.IdUsuarioEmisor}";

            var msgDto = new MensajeDto
            {
                IdMensaje = nuevoMensaje.IdMensaje,
                IdConversacion = nuevoMensaje.IdConversacion,
                IdUsuarioEmisor = nuevoMensaje.IdUsuarioEmisor,
                NombreEmisor = nombreEmisor,
                Contenido = nuevoMensaje.Contenido,
                EnviadoEn = nuevoMensaje.EnviadoEn,
                Leido = nuevoMensaje.Leido
            };

            return Result<MensajeDto>.Success(201, msgDto, "Mensaje enviado exitosamente.", true);
        }
    }
}