using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ConversacionesDtos;
using Agro_Trade.Application.Common.Interface;




namespace Agro_Trade.Application.Features.Conversaciones.Commands
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

            // Validar que ambos usuarios existan antes de insertar (evita el FK violación)
            var idCliente = request.Dto.IdUsuarioCliente;
            var idReceptor = request.Dto.IdUsuarioReceptor;

            var clienteExiste = await _unitOfWork.Users.AnyAsync(u => u.IdUsuario == idCliente, ct);
            if (!clienteExiste)
                return Result<int>.Failure(404, $"El usuario cliente con id {idCliente} no existe.");

            var receptorExiste = await _unitOfWork.Users.AnyAsync(u => u.IdUsuario == idReceptor, ct);
            if (!receptorExiste)
                return Result<int>.Failure(404, $"El usuario receptor con id {idReceptor} no existe.");

            // Si ambos ids son iguales y no hay más de 2 participantes, seguimos igual pero
            // para evitar rows duplicadas en participantes:
            var idsUnicos = new HashSet<int> { idCliente, idReceptor };

            
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

                var participantes = new List<ConversacionParticipante>();
                foreach (var uid in idsUnicos)
                {
                    participantes.Add(new ConversacionParticipante
                    {
                        IdConversacion = nuevaConversacion.IdConversacion,
                        IdUsuario = uid
                    });
                }

                
                foreach (var participante in participantes)
                {
                    await _unitOfWork.ConversacionParticipantes.AddAsync(participante, ct);
                }

                await _unitOfWork.SaveChangesAsync(ct);
                await _unitOfWork.CommitAsync(ct); 

                return Result<int>.Success(201, nuevaConversacion.IdConversacion, "Conversación iniciada con éxito.", true);
            }
            catch (Exception ex)
            {
                await _unitOfWork.RollbackAsync(ct); 
                return Result<int>.Failure(500, $"Ocurrió un error al iniciar la conversación: {ex.Message}");
            }

        }


    }
}