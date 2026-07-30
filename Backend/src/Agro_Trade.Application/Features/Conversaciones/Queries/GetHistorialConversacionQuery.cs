using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ConversacionesDtos;
using Agro_Trade.Application.Common.Interface;


namespace Agro_Trade.Application.Features.Conversaciones.Queries
{

    public record GetHistorialConversacionQuery(int IdConversacion, int PageIndex, int PageSize) : IRequest<Result<PagedResponse<MensajeDto>>>;


    public class GetHistorialConversacionQueryHandler : IRequestHandler<GetHistorialConversacionQuery, Result<PagedResponse<MensajeDto>>>
    {

        private readonly IUnitofWork _unitOfWork;

        public GetHistorialConversacionQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<PagedResponse<MensajeDto>>> Handle(GetHistorialConversacionQuery request, CancellationToken ct)
        {
            if (request.PageIndex <= 0 || request.PageSize <= 0)
                return Result<PagedResponse<MensajeDto>>.Failure(400, "Los parámetros de paginación son inválidos.");

            
            var mensajes = await _unitOfWork.Mensajes.FindAsync(
                m => m.IdConversacion == request.IdConversacion,
                ct,
                m => m.Emisor);

            if (mensajes == null || !mensajes.Any())
                return Result<PagedResponse<MensajeDto>>.Success(200, PagedResponse<MensajeDto>.ToPagedResponse(new List<MensajeDto>(), request.PageIndex, request.PageSize, 0), "No hay mensajes en esta conversación.", true);

            // Ordenamos descendente para paginar desde lo más reciente a lo más antiguo (típico de un chat)
            var queryBase = mensajes.OrderByDescending(m => m.EnviadoEn).ToList();
            var totalRegisters = queryBase.Count;

            var mensajesPaginados = queryBase
                .Skip((request.PageIndex - 1) * request.PageSize)
                .Take(request.PageSize)
                .Select(m => new MensajeDto
                {
                    IdMensaje = m.IdMensaje,
                    IdConversacion = m.IdConversacion,
                    IdUsuarioEmisor = m.IdUsuarioEmisor,
                    NombreEmisor = m.Emisor?.NombreCompleto ?? "Usuario Desconocido",
                    Contenido = m.Contenido,
                    EnviadoEn = m.EnviadoEn,
                    Leido = m.Leido
                }).ToList();

           
            mensajesPaginados.Reverse();

            var response = PagedResponse<MensajeDto>.ToPagedResponse(mensajesPaginados, request.PageIndex, request.PageSize, totalRegisters);

            return Result<PagedResponse<MensajeDto>>.Success(200, response, "Historial obtenido correctamente.", true);
        }
        
    }
}