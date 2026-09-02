using MediatR;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Features.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Features.AgroBot.Commands;
using System.Security.Claims;

namespace Agro_Trade.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    
   
    public class AgroBotController : ControllerBase
    {
        private readonly IMediator _mediator;
        public AgroBotController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("push-request")]
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
    }
}

