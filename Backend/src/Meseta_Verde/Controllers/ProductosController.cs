using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ProductosDtos;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Application.Features.Productos.Commands;
using Meseta_Verde.Application.Features.Productos.Queries;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductosController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IUnitOfWork _unitOfWork;

        public ProductosController(IMediator mediator, IUnitOfWork unitOfWork)
        {
            _mediator = mediator;
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public async Task<ActionResult<Result<List<ProductoDto>>>> Get()
        {
            var result = await _mediator.Send(new GetProductosQuery());
            return Ok(result);
        }

        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromBody] CreateProductoCommand command)
        {
            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<Result<bool>>> Update([FromRoute] int id, [FromBody] UpdateProductoDto dto)
        {
            if (id <= 0)
            {
                return BadRequest(Result<bool>.Failure(400, "El ID del producto es inválido."));
            }

            var result = await _mediator.Send(new UpdateProductoCommand(id, dto.IdCategoria, dto.IdProveedor, dto.Nombre, dto.Descripcion, dto.UnidadMedida));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        [HttpPatch("{id}")]
        public async Task<ActionResult<Result<bool>>> Patch([FromRoute] int id, [FromBody] PatchProductoDto dto)
        {
            if (id <= 0)
            {
                return BadRequest(Result<bool>.Failure(400, "El ID del producto es inválido."));
            }

            if (dto is null)
            {
                return BadRequest(Result<bool>.Failure(400, "No se proporcionaron datos para actualizar."));
            }

            var producto = await _unitOfWork.Productos.GetByIdAsync(id, CancellationToken.None);
            if (producto is null)
            {
                return NotFound(Result<bool>.Failure(404, "No se encontró el producto."));
            }

            // Actualizar solo los campos que vienen en el DTO
            if (dto.IdCategoria.HasValue)
            {
                var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == dto.IdCategoria.Value, CancellationToken.None);
                if (!categoriaExiste)
                {
                    return NotFound(Result<bool>.Failure(404, "La categoría especificada no existe."));
                }
                producto.IdCategoria = dto.IdCategoria.Value;
            }

            if (dto.IdProveedor.HasValue)
            {
                var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == dto.IdProveedor.Value, CancellationToken.None);
                if (!proveedorExiste)
                {
                    return NotFound(Result<bool>.Failure(404, "El proveedor especificado no existe."));
                }
                producto.IdProveedor = dto.IdProveedor.Value;
            }

            if (!string.IsNullOrEmpty(dto.Nombre))
            {
                producto.Nombre = dto.Nombre;
            }

            if (dto.Descripcion is not null)
            {
                producto.Descripcion = dto.Descripcion;
            }

            if (!string.IsNullOrEmpty(dto.UnidadMedida))
            {
                producto.UnidadMedida = dto.UnidadMedida;
            }

            await _unitOfWork.Productos.UpdateAsync(producto, CancellationToken.None);
            await _unitOfWork.SaveChangesAsync(CancellationToken.None);

            return Ok(Result<bool>.Succes(200, true, "Producto actualizado parcialmente correctamente.", true));
        }
        
    }
}