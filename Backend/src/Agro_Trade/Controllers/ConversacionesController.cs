using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ConversacionesDtos;
using Agro_Trade.Application.Features.Conversaciones.Commands;
using Microsoft.AspNetCore.Authorization;
using Agro_Trade.Application.Features.Conversaciones.Queries;
using Microsoft.AspNetCore.SignalR;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ConversacionesController : ControllerBase
    {

        private readonly IMediator _mediator;
        private readonly Microsoft.AspNetCore.SignalR.IHubContext<Agro_Trade.Hubs.ChatHub> _hubContext;

        public ConversacionesController(IMediator mediator, Microsoft.AspNetCore.SignalR.IHubContext<Agro_Trade.Hubs.ChatHub> hubContext)
        {
            _mediator = mediator;
            _hubContext = hubContext;
        }

        /// <summary>
        /// Inicia una nueva conversación o retorna la existente basada en el ID del pedido.
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> StartConversacion([FromBody] StartConversacionDto dto, CancellationToken ct)
        {
            var result = await _mediator.Send(new StartConversacionCommand(dto), ct);
            return StatusCode(result.StatusCode, result);
        }



        /// <summary>
        /// Envía un nuevo mensaje dentro de una conversación activa.
        /// </summary>
        [HttpPost("{idConversacion}/mensajes")]
        public async Task<IActionResult> SendMessage([FromRoute] int idConversacion, [FromBody] SendMessageDto dto, CancellationToken ct)
        {
            if (idConversacion != dto.IdConversacion)
                return BadRequest(Result<int>.Failure(400, "El ID de la ruta no coincide con el cuerpo de la petición."));

            var result = await _mediator.Send(new SendMessageCommand(dto), ct);
            
            if (result.IsSuccess && result.Data != null)
            {
                // Emitir el mensaje por SignalR al grupo de esta conversación
                await _hubContext.Clients.Group(idConversacion.ToString())
                    .SendAsync("ReceiveMessage", result.Data, ct);
            }
            
            return StatusCode(result.StatusCode, result);
        }



        /// <summary>
        /// Obtiene el historial paginado de mensajes de una conversación.
        /// </summary>
        [HttpGet("{idConversacion}/mensajes")]
        public async Task<IActionResult> GetHistorial([FromRoute] int idConversacion, CancellationToken ct, [FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 20)
        {
            var result = await _mediator.Send(new GetHistorialConversacionQuery(idConversacion, pageIndex, pageSize), ct);
            return StatusCode(result.StatusCode, result);
        }
        

        
    }
}