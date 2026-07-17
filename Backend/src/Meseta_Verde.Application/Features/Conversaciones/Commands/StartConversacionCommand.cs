using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ConversacionesDtos;
using Meseta_Verde.Application.Common.Interface;




namespace Meseta_Verde.Application.Features.Conversaciones.Commands
{
    public record StartConversacionCommand(StartConversacionDto Dto) : IRequest<Result<int>>;

    public class StartConversacionCommandHandler : IRequestHandler<StartConversacionCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public StartConversacionCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }


        public async Task<Result<int>> Handle(StartConversacionCommand request, CancellationToken ct)
        {
            
            var conversacionExistente = await _unitOfWork.Conversaciones
                .FirstOrDefaultAsync(c => c.IdPedido == request.Dto.IdPedido, ct);

            if (conversacionExistente != null)
            {
                return Result<int>.Success(200, conversacionExistente.IdConversacion, "La conversación ya existía.", true);
            }

            
            await _unitOfWork.BeginTransactionAsync(ct);

            try
            {
                var nuevaConversacion = new Conversacion
                {
                    IdPedido = request.Dto.IdPedido,
                    CreadaEn = DateTime.UtcNow
                };

                await _unitOfWork.Conversaciones.AddAsync(nuevaConversacion, ct);
                await _unitOfWork.SaveChangesAsync(ct); 

                // 3. Crear los participantes
                var participantes = new List<ConversacionParticipante>
                {
                    new ConversacionParticipante { IdConversacion = nuevaConversacion.IdConversacion, IdUsuario = request.Dto.IdUsuarioCliente },
                    new ConversacionParticipante { IdConversacion = nuevaConversacion.IdConversacion, IdUsuario = request.Dto.IdUsuarioReceptor }
                };

                
                foreach (var participante in participantes)
                {
                    await _unitOfWork.ConversacionParticipantes.AddAsync(participante, ct);
                }

                await _unitOfWork.SaveChangesAsync(ct);
                await _unitOfWork.CommitAsync(ct); 

                return Result<int>.Success(201, nuevaConversacion.IdConversacion, "Conversación iniciada con éxito.", true);
            }
            catch (Exception)
            {
                await _unitOfWork.RollbackAsync(ct); 
                return Result<int>.Failure(500, "Ocurrió un error al iniciar la conversación.");
            }

        }


    }
}