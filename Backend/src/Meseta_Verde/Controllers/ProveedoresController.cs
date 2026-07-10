using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ProveedoresDtos;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Application.Features.Proveedores.Commands;
using Meseta_Verde.Application.Features.Proveedores.Queries;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
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

        [HttpGet("{id}")]
        public async Task<ActionResult<Result<ProveedorDto?>>> GetById(int id)
        {
            var result = await _mediator.Send(new GetProveedorByIdQuery(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
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
    }
}