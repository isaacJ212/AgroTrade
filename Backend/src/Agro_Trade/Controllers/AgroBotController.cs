using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Features.AgroBot.Commands;
using Agro_Trade.Application.Features.AgroBot.Queries;
using System.Security.Claims;

namespace Agro_Trade.Controllers
{
    /// <summary>
    /// Controlador para la gestión y comunicación con el asistente inteligente AgroBot.
    /// Proporciona endpoints para interactuar con el modelo de lenguaje Gemini, consultar el historial
    /// conversacional y listar las conversaciones activas asociadas al usuario autenticado.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    public class AgroBotController : ControllerBase
    {
        private readonly IMediator _mediator;

        /// <summary>
        /// Inicializa una nueva instancia de <see cref="AgroBotController"/>.
        /// </summary>
        /// <param name="mediator">Instancia del mediador CQRS.</param>
        public AgroBotController(IMediator mediator)
        {
            _mediator = mediator;
        }

        /// <summary>
        /// Envía un mensaje o solicitud a AgroBot para el módulo temático indicado, gestionando el contexto conversacional y generando la respuesta con Gemini.
        /// </summary>
        /// <remarks>
        /// Si no se envía un <c>chatId</c> en el cuerpo de la petición, el sistema generará automáticamente un nuevo identificador (GUID) para iniciar una conversación independiente.
        /// El campo <c>Module</c> especifica qué directriz o prompt de sistema embebido en el backend se aplicará.
        /// Se implementa un mecanismo de resiliencia con hasta 3 reintentos automáticos (con pausas de 10 segundos) ante posibles errores de saturación en la API de Gemini (ServerError).
        /// </remarks>
        /// <param name="dto">Datos de la petición que incluyen el mensaje del usuario, el nombre del módulo y opcionalmente el chatId.</param>
        /// <param name="ct">Token de cancelación para abortar la operación asíncrona si es necesario.</param>
        /// <returns>Resultado con la respuesta del modelo inteligente y el identificador de la conversación.</returns>
        /// <response code="200">Respuesta generada exitosamente por AgroBot.</response>
        /// <response code="400">Si el mensaje o módulo son nulos, vacíos o no cumplen con las validaciones requeridas.</response>
        /// <response code="401">Si el token JWT no es suministrado, es inválido o no contiene un identificador de usuario válido.</response>
        /// <response code="503">Si el servicio de IA de Gemini se encuentra saturado temporalmente tras agotar los 3 reintentos.</response>
        [HttpPost("push-request")]
        [Consumes("application/json")]
        [ProducesResponseType(typeof(Result<BotResponse>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(object), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(object), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(object), StatusCodes.Status503ServiceUnavailable)]
        public async Task<IActionResult> PushRequest([FromBody] BotRequest dto, CancellationToken ct)
        {
            var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(id))
            {
                return Unauthorized(new { ErrorMessage = "Usuario no autenticado." });
            }
    
            var result = await _mediator.Send(new PushRequest(UserId: id, BotRequest: dto), ct);

            if (result.IsSuccess)
            {
                return Ok(result);
            }

            return StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }

        /// <summary>
        /// Obtiene la lista de todas las conversaciones activas pertenecientes al usuario autenticado.
        /// </summary>
        /// <remarks>
        /// Recupera las conversaciones indexadas en memoria (<c>IMemoryCache</c>) con expiración deslizante de 24 horas para el usuario actual.
        /// </remarks>
        /// <param name="ct">Token de cancelación para la operación asíncrona.</param>
        /// <returns>Colección de conversaciones con sus respectivos identificadores e historiales de mensajes.</returns>
        /// <response code="200">Lista de conversaciones recuperada exitosamente (puede ser una lista vacía si el usuario no tiene conversaciones activas).</response>
        /// <response code="401">Si el token JWT no es suministrado o no contiene un identificador de usuario válido.</response>
        [HttpGet("conversations")]
        [ProducesResponseType(typeof(Result<List<BotConversation>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(object), StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> GetConversations(CancellationToken ct)
        {
            var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(id))
            {
                return Unauthorized(new { ErrorMessage = "Usuario no autenticado." });
            }

            var result = await _mediator.Send(new GetUserConversationsQuery(id), ct);

            if (result.IsSuccess)
            {
                return Ok(result);
            }

            return StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }

        /// <summary>
        /// Obtiene el historial cronológico de mensajes de una conversación específica perteneciente al usuario autenticado.
        /// </summary>
        /// <remarks>
        /// Filtra y retorna los intercambios de mensajes registrados (roles de usuario y modelo) para el <c>chatId</c> especificado dentro de la memoria caché.
        /// </remarks>
        /// <param name="chatId">Identificador único de la conversación a consultar.</param>
        /// <param name="ct">Token de cancelación para la operación asíncrona.</param>
        /// <returns>Lista secuencial de mensajes (rol y contenido) correspondientes a la conversación solicitada.</returns>
        /// <response code="200">Historial obtenido exitosamente.</response>
        /// <response code="400">Si el identificador de chat es nulo, vacío o inválido.</response>
        /// <response code="401">Si el token JWT no es suministrado o no contiene un identificador de usuario válido.</response>
        [HttpGet("conversations/{chatId}")]
        [ProducesResponseType(typeof(Result<List<History>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(object), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(object), StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> GetConversationHistory([FromRoute] string chatId, CancellationToken ct)
        {
            var id = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(id))
            {
                return Unauthorized(new { ErrorMessage = "Usuario no autenticado." });
            }

            var result = await _mediator.Send(new GetChatHistoryQuery(chatId, id), ct);

            if (result.IsSuccess)
            {
                return Ok(result);
            }

            return StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }
    }
}

