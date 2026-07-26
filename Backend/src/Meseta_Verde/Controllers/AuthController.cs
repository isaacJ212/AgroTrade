using MediatR;
using Meseta_Verde.Application.Common.DTOs.AuthServices;
using Meseta_Verde.Application.Features.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class AuthController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AuthController(IMediator mediator)
        {
            _mediator = mediator;
        }

        /// <summary>
        /// Inicio de sesión tradicional mediante Correo y Contraseña.
        /// </summary>
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto, CancellationToken ct)
        {
            // Enviamos el comando tradicional (asumiendo que devuelve un LoginResponse o un string)
            var result = await _mediator.Send(new LoginCommand(dto), ct);

            if (result.IsSuccess)
            {
                return Ok(result); // Devuelve el token y los datos del usuario
            }

            return StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }

        /// <summary>
        /// Inicio de sesión y registro automático mediante Google Sign-In.
        /// </summary>
        [HttpPost("google-signin")]
        public async Task<IActionResult> GoogleSignIn([FromBody] OAuthSignInDto dto, CancellationToken ct)
        {
            // Enviamos el comando de Google que armamos hace un momento
            var result = await _mediator.Send(new GoogleSignInCommand(dto), ct);

            if (result.IsSuccess)
            {
                return Ok(result); // Devuelve el LoginResponse con el JWT local
            }

            return StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }


        [HttpPost("verify-code")]
        public async Task<IActionResult> VerifyCode([FromBody] VerifyCodeDto dto, CancellationToken ct)
        {
            var result = await _mediator.Send(new VerifyCodeCommand(dto), ct);

            if (result.IsSuccess)
            {
                return Ok(result);
            }

            return StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }
    }
}

