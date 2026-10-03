using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProveedoresDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Features.Proveedores.Commands;
using Agro_Trade.Application.Features.Proveedores.Queries;
using Agro_Trade.Application.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProveedoresController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IUnitofWork _unitOfWork;

        public ProveedoresController(IMediator mediator, IUnitofWork unitOfWork)
        {
            _mediator = mediator;
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public async Task<ActionResult<Result<List<ProveedorDto>>>> Get()
        {
            var result = await _mediator.Send(new GetProveedoresQuery());
            return Ok(result);
        }

        [HttpGet("destacados")]
        public async Task<ActionResult<Result<List<ProveedorDto>>>> GetDestacados([FromQuery] int limit = 5)
        {
            var result = await _mediator.Send(new GetProveedoresDestacadosQuery(limit));
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Result<ProveedorDto?>>> GetById(int id)
        {
            var result = await _mediator.Send(new GetProveedorByIdQuery(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        [HttpGet("mine")]
        [Authorize]
        public async Task<ActionResult<Result<int>>> GetMiProveedor()
        {
            Console.WriteLine("[DEBUG] Llamada al endpoint GET /api/Proveedores/mine");
            int userId;
            try
            {
                if (!int.TryParse(User.GetUserId(), out userId))
                {
                    Console.WriteLine("[DEBUG] GET /api/Proveedores/mine -> JWT invalido (no se pudo extraer userId).");
                    return Unauthorized(Result<int>.Failure(401, "JWT invalido."));
                }
            }
            catch (Exception)
            {
                Console.WriteLine("[DEBUG] GET /api/Proveedores/mine -> Exception al parsear userId.");
                return Unauthorized(Result<int>.Failure(401, "JWT invalido."));
            }

            Console.WriteLine($"[DEBUG] GET /api/Proveedores/mine -> Buscando Proveedor para IdUsuario: {userId}");
            var proveedores = await _unitOfWork.Proveedores.GetAllAsync(CancellationToken.None);
            var miProveedor = proveedores.FirstOrDefault(p => p.IdUsuario == userId);

            if (miProveedor == null)
            {
                Console.WriteLine($"[DEBUG] GET /api/Proveedores/mine -> No se encontró Proveedor para IdUsuario: {userId}. Se procederá a crearlo.");
                var user = await _unitOfWork.Usuarios.GetByIdAsync(userId, CancellationToken.None);
                if (user == null) 
                {
                    Console.WriteLine($"[DEBUG] GET /api/Proveedores/mine -> Usuario {userId} no encontrado en la DB.");
                    return NotFound(Result<int>.Failure(404, "Usuario no encontrado"));
                }
                
                try 
                {
                    miProveedor = new Agro_Trade.Domain.Entities.Proveedor
                    {
                        IdUsuario = userId,
                        NombreProveedor = $"{(user.Nombre + " " + user.PrimerApellido).Trim()}"
                    };
                    await _unitOfWork.Proveedores.AddAsync(miProveedor, CancellationToken.None);
                    await _unitOfWork.SaveChangesAsync(CancellationToken.None);
                    Console.WriteLine($"[DEBUG] GET /api/Proveedores/mine -> PROVEEDOR CREADO EXITOSAMENTE. Nuevo IdProveedor: {miProveedor.IdProveedor}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[DEBUG] GET /api/Proveedores/mine -> ERROR AL CREAR PROVEEDOR: {ex.Message}");
                    if (ex.InnerException != null) Console.WriteLine($"[DEBUG] InnerException: {ex.InnerException.Message}");
                }
            }
            else
            {
                Console.WriteLine($"[DEBUG] GET /api/Proveedores/mine -> Proveedor existente encontrado. IdProveedor: {miProveedor.IdProveedor}");
            }

            return Ok(Result<int>.Success(200, miProveedor?.IdProveedor ?? 0, "Proveedor recuperado exitosamente.", true));
        }

        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromBody] CreateProveedorCommand command)
        {
            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<Result<bool>>> Update([FromRoute] int id, [FromBody] UpdateProveedorDto dto)
        {
            if (id <= 0)
            {
                return BadRequest(Result<bool>.Failure(400, "El ID del proveedor es inválido."));
            }

            var result = await _mediator.Send(new UpdateProveedorCommand(id, dto.IdUsuario, dto.NombreProveedor, dto.NombreFinca, dto.UbicacionGps, dto.Biografia, dto.CalificacionPromedio));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        [HttpPatch("{id}")]
        public async Task<ActionResult<Result<bool>>> Patch([FromRoute] int id, [FromBody] PatchProveedorDto dto)
        {
            if (id <= 0)
            {
                return BadRequest(Result<bool>.Failure(400, "El ID del proveedor es inválido."));
            }

            if (dto is null)
            {
                return BadRequest(Result<bool>.Failure(400, "No se proporcionaron datos para actualizar."));
            }

            var proveedor = await _unitOfWork.Proveedores.GetByIdAsync(id, CancellationToken.None);
            if (proveedor is null)
            {
                return NotFound(Result<bool>.Failure(404, "No se encontró el proveedor."));
            }

            if (dto.IdUsuario.HasValue)
            {
                // Validar que el usuario exista
                var usuarioExiste = await _unitOfWork.Usuarios.AnyAsync(c => c.IdUsuario == dto.IdUsuario.Value, CancellationToken.None);
                if (!usuarioExiste)
                {
                    return NotFound(Result<bool>.Failure(404, "El usuario especificado no existe"));
                }
                proveedor.IdUsuario = dto.IdUsuario.Value;
            }

            if (!string.IsNullOrEmpty(dto.NombreProveedor))
            {
                proveedor.NombreProveedor = dto.NombreProveedor;
            }

            if (dto.NombreFinca is not null)
            {
                proveedor.NombreFinca = dto.NombreFinca;
            }

            if (dto.UbicacionGps is not null)
            {
                proveedor.UbicacionGps = dto.UbicacionGps;
            }

            if (dto.Biografia is not null)
            {
                proveedor.Biografia = dto.Biografia;
            }

            if (dto.CalificacionPromedio.HasValue)
            {
                proveedor.CalificacionPromedio = dto.CalificacionPromedio.Value;
            }

            await _unitOfWork.Proveedores.UpdateAsync(proveedor, CancellationToken.None);
            await _unitOfWork.SaveChangesAsync(CancellationToken.None);

            return Ok(Result<bool>.Success(200, true, "Proveedor actualizado parcialmente correctamente.", true));
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<Result<bool>>> Delete(int id)
        {
            var result = await _mediator.Send(new DeleteProveedorCommand(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        [HttpGet("ventas")]
        [Authorize]
        public async Task<ActionResult<Result<List<VentaProveedorDto>>>> GetVentas()
        {
            int userId;
            try
            {
                if (!int.TryParse(User.GetUserId(), out userId))
                    return Unauthorized(Result<List<VentaProveedorDto>>.Failure(401, "JWT invalido."));
            }
            catch (InvalidOperationException)
            {
                return Unauthorized(Result<List<VentaProveedorDto>>.Failure(401, "JWT invalido."));
            }

            var result = await _mediator.Send(new GetVentasProveedorQuery(userId));
            return StatusCode(result.StatusCode, result);
        }
    }
}
