using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProductosDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Features.Productos.Commands;
using Agro_Trade.Application.Features.Productos.Queries;
using Agro_Trade.Application.Features.UnidadesDeMedida.Queries;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductosController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IUnitofWork _unitOfWork;

        public ProductosController(IMediator mediator, IUnitofWork unitOfWork)
        {
            _mediator = mediator;
            _unitOfWork = unitOfWork;
        }

        // GET api/productos
        [HttpGet]
        public async Task<ActionResult> Get(
            [FromQuery] int page = 1,
            [FromQuery] int limit = 20,
            [FromQuery] string? search = null,
            [FromQuery] int? idProveedor = null,
            [FromQuery] int? categoriaId = null)
        {
            var result = await _mediator.Send(new GetProductosQuery(page, limit, search, idProveedor, categoriaId));
            return Ok(result);
        }

        // GET api/productos/ofertas
        [HttpGet("ofertas")]
        public async Task<ActionResult> GetOfertas([FromQuery] int limit = 5)
        {
            var result = await _mediator.Send(new GetProductosOfertasQuery(limit));
            return Ok(result);
        }

        // GET api/productos/cercanos
        [HttpGet("cercanos")]
        public async Task<ActionResult> GetCercanos([FromQuery] int limit = 10)
        {
            var result = await _mediator.Send(new GetProductosCercanosQuery(limit));
            return Ok(result);
        }

        // GET api/productos/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Result<ProductoDto?>>> GetById(int id)
        {
            var result = await _mediator.Send(new GetProductoByIdQuery(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        // POST api/productos
        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromBody] CreateProductoCommand command)
        {
            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }

        // PUT api/productos/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<Result<bool>>> Update([FromRoute] int id, [FromBody] UpdateProductoDto dto)
        {
            if (id <= 0)
                return BadRequest(Result<bool>.Failure(400, "El ID del producto es inválido."));

            var result = await _mediator.Send(new UpdateProductoCommand(id, dto.IdCategoria, dto.IdProveedor, dto.IdUnidadMedida, dto.Nombre, dto.Descripcion));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        // PATCH api/productos/{id}
        [HttpPatch("{id}")]
        public async Task<ActionResult<Result<bool>>> Patch([FromRoute] int id, [FromBody] PatchProductoDto dto)
        {
            if (id <= 0)
                return BadRequest(Result<bool>.Failure(400, "El ID del producto es inválido."));

            if (dto is null)
                return BadRequest(Result<bool>.Failure(400, "No se proporcionaron datos para actualizar."));

            var producto = await _unitOfWork.Productos.GetByIdAsync(id, CancellationToken.None);
            if (producto is null)
                return NotFound(Result<bool>.Failure(404, "No se encontró el producto."));

            if (dto.IdCategoria.HasValue)
            {
                var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == dto.IdCategoria.Value, CancellationToken.None);
                if (!categoriaExiste)
                    return NotFound(Result<bool>.Failure(404, "La categoría especificada no existe."));
                producto.IdCategoria = dto.IdCategoria.Value;
            }

            if (dto.IdProveedor.HasValue)
            {
                var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == dto.IdProveedor.Value, CancellationToken.None);
                if (!proveedorExiste)
                    return NotFound(Result<bool>.Failure(404, "El proveedor especificado no existe."));
                producto.IdProveedor = dto.IdProveedor.Value;
            }

            if (dto.IdUnidadMedida.HasValue)
            {
                var unidadExiste = await _unitOfWork.UnidadesDeMedida.AnyAsync(u => u.Id == dto.IdUnidadMedida.Value, CancellationToken.None);
                if (!unidadExiste)
                    return NotFound(Result<bool>.Failure(404, "La unidad de medida especificada no existe."));
                producto.IdUnidadDeMedida = dto.IdUnidadMedida.Value;
            }

            if (!string.IsNullOrEmpty(dto.Nombre))
                producto.Nombre = dto.Nombre;

            if (dto.Descripcion is not null)
                producto.Descripcion = dto.Descripcion;

            await _unitOfWork.Productos.UpdateAsync(producto, CancellationToken.None);
            await _unitOfWork.SaveChangesAsync(CancellationToken.None);

            return Ok(Result<bool>.Success(200, true, "Producto actualizado parcialmente correctamente.", true));
        }

        // DELETE api/productos/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult<Result<bool>>> Delete(int id)
        {
            var result = await _mediator.Send(new DeleteProductoCommand(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }
    }

    // ---------------------------------------------------------------------------
    // Catálogo de unidades de medida
    // ---------------------------------------------------------------------------
    [ApiController]
    [Route("api/[controller]")]
    public class UnidadesDeMedidaController : ControllerBase
    {
        private readonly IMediator _mediator;

        public UnidadesDeMedidaController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // GET api/unidadesdemedida
        [HttpGet]
        public async Task<ActionResult> Get()
        {
            var result = await _mediator.Send(new GetUnidadesDeMedidaQuery());
            return Ok(result);
        }
    }
}