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
    public record SendMessageCommand(SendMessageDto Dto) : IRequest<Result<int>>;


    public class SendMessageCommandHandler : IRequestHandler<SendMessageCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public SendMessageCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(SendMessageCommand request, CancellationToken ct)
        {
            var conversacion = await _unitOfWork.Conversaciones.GetByIdAsync(request.Dto.IdConversacion, ct);
            if (conversacion == null)
                return Result<int>.Failure(404, "La conversación no existe.");

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

            return Result<int>.Success(201, nuevoMensaje.IdMensaje, "Mensaje enviado exitosamente.", true);
        }
    }
}