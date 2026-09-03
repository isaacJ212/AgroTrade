using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.DTOs.UsersDtos;
using Agro_Trade.Application.Features.Auth;
using Agro_Trade.Application.Features.Usuarios.Commands;
using Agro_Trade.Application.Features.Usuarios.Queries;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Runtime.InteropServices;

namespace Agro_Trade.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class UsersController : ControllerBase
    {
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly IMediator mediator;

        public UsersController(IHttpContextAccessor con, IMediator med)
        {
            mediator = med;
            _contextAccessor = con;
        }
        /// <summary>
        /// Obtiene todos los usuarios.
        /// </summary>
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 50, CancellationToken ct = default)
        {
            var result = await mediator.Send(new GetUsersQuery { PageIndex = pageIndex, PageSize = pageSize }, ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }

        /// <summary>
        /// Obtiene los datos de un usuario mediante su ID único.
        /// </summary>
        /// <param name="id">ID numérico del usuario.</param>
        /// <param name="ct">Token de cancelación.</param>
        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id, CancellationToken ct)
        {

            var result = await mediator.Send(new GetUserByIdQuery(id), ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }
        /// <summary>
        /// Busca un usuario en el sistema utilizando su correo electrónico.
        /// </summary>
        /// <param name="email">Email registrado del usuario.</param>
        /// <param name="ct">Token de cancelación.</param>
        [Authorize]
        [HttpGet("email")]
        public async Task<IActionResult> GetByEmail([FromQuery] string email, CancellationToken ct)
        {
            var result = await mediator.Send(new GetUserByEmailQuery(email), ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }

        /// <summary>
        /// Registra un nuevo usuario en la base de datos.
        /// </summary>
        /// <param name="dto">Objeto con los datos bÃ¡sicos (Nombre, Email, Password, etc).</param>
        /// <param name="ct">Token de cancelaciÃ³n.</param>
        [AllowAnonymous]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateUserDto dto, CancellationToken ct)
        {
            var resutl = await mediator.Send(new AddUserCommand(dto), ct);
            if (!resutl.IsSuccess)
                return StatusCode(resutl.StatusCode, new { ErrorMesagge = resutl.Message });
            return CreatedAtAction(nameof(GetById), new { Id = resutl.Data.Id }, resutl);
        }
        /// <summary>
        /// Actualiza la información del perfil del usuario (Nombre, Teléfono, etc).
        /// </summary>
        /// <param name="id">ID del usuario a modificar.</param>
        /// <param name="dto">Datos a actualizar.</param>
        /// <param name="ct">Token de cancelación.</param>
        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update([FromRoute]int id, [FromBody] UpdateUserDto dto, CancellationToken ct)
        {
            var tokenIdUserStr = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            int.TryParse(tokenIdUserStr, out int tokenIdUser);

            bool isAdmin = User.IsInRole("Admin");
            if (!isAdmin && tokenIdUser != id)
                return StatusCode(403, new { mensaje = "Acceso denegado: No puedes modificar un perfil ajeno." });

            var result = await mediator.Send(new UpdateUserCommand(id, dto));
            return result.IsSuccess ? NoContent() : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }
        /// <summary>
        /// Cambia la contraseña actual por una nueva. Requiere validación de sesión.
        /// </summary>
        /// <param name="id">ID del usuario.</param>
        /// <param name="dto">Contraseña actual y nueva contraseña.</param>
        /// <param name="ct">Token de cancelación.</param>
        [Authorize]
        [HttpPatch("{id}/Password")]
        public async Task<IActionResult> UpdatePassword([FromRoute] int id, [FromBody] UpdatePasswordDto dto, CancellationToken ct)
        {
            var tokenUserIdStr = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            int.TryParse(tokenUserIdStr, out int tokenUserId);

            // 2. revisar si tiene el rol "Admin" 
            bool esAdmin = User.IsInRole("Admin");

            // 3. El filtro de seguridad: Si NO es admin Y el ID del token NO coincide con el de la ruta se deniega el acceso
            if (!esAdmin && tokenUserId != id)
            {
                return StatusCode(403, new { mensaje = "Acceso denegado: No puedes modificar un perfil ajeno." });
            }
            var result = await mediator.Send(new UpdatePasswordCommand(id, dto));
            return result.IsSuccess ? NoContent() : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }
        /// <summary>
        /// Elimina permanentemente a un usuario del sistema (Requiere permisos de administrador o ser el mismo usuario).
        /// </summary>
        /// <param name="id">ID del usuario a eliminar.</param>
        /// <param name="ct">Token de cancelación.</param>
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id, CancellationToken ct)
        {
            var tokenUserIdStr = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            int.TryParse(tokenUserIdStr, out int tokenUserId);
            bool isAdmin = User.IsInRole("Admin");
            if (!isAdmin && tokenUserId != id)
                return StatusCode(403, new { mensaje = "Acceso denegado: No puedes eliminar un perfil ajeno." });   
            var result = await mediator.Send(new DeleteUserCommand(id));
            return result.IsSuccess ? NoContent() : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }

        /// <summary>
        /// Alterna el estado de la cuenta de un usuario. (Requiere permisos de administrador).
        /// </summary>
        /// <param name="id">ID numérico del usuario.</param>
        /// <param name="ct">Token de cancelación.</param>
        [Authorize(Roles = "Administrador")]
        [HttpPatch("{id}/toggle-status")]
        public async Task<IActionResult> ToggleUserStatus(int id, CancellationToken ct)
        {
            var result = await mediator.Send(new ToggleUserStatusCommand(id), ct);
            return result.IsSuccess ? NoContent() : StatusCode(result.StatusCode, new { ErrorMesagge = result.Message });
        }


    }
}
