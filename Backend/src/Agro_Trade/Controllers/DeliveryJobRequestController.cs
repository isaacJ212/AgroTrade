using MediatR;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Commands;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries;
using Agro_Trade.Application.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class DeliveryJobRequestController : ControllerBase
    {
        private readonly IMediator _mediator;
        public DeliveryJobRequestController(IMediator mediatr)
        {
            _mediator = mediatr;
        }

        [HttpGet]
        [Authorize(Roles = "Administrador")]
        public async Task<IActionResult> GetUnseenRequest(CancellationToken ct, [FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 8)
        {
            var request = await _mediator.Send(new GetUnSeenRequestQuery(pageIndex, pageSize), ct);
            return StatusCode(request.StatusCode, request);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id, CancellationToken ct)
        {
            if(id <=0)
            {
                return BadRequest("Id Invalido");
            }
            var request = await _mediator.Send(new GetByIdQuery(id), ct);
            return StatusCode(request.StatusCode, request);
        }

        [HttpPost]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> CreateJobRequest([FromForm] CreateDatosRepartidorDto dto, CancellationToken ct)
        {
            if (dto is null)
            {
                return BadRequest("Los datos de la solicitud son obligatorios.");
            }

            var photoValidation = ValidatePhotos(dto);
            if (photoValidation is not null)
            {
                return BadRequest(photoValidation);
            }

            var id = User.GetUserId();
            if (!int.TryParse(id, out var valId) || valId <= 0)
            {
                return Unauthorized("No se pudo identificar al usuario autenticado.");
            }

            var request = await _mediator.Send(new CreateDeliveryReqCommand(valId, dto), ct);

            if (!request.IsSuccess)
            {
                return StatusCode(request.StatusCode, request);
            }

            return CreatedAtAction(nameof(GetById), new { id = request.Data.IdSolicitud }, request);

        }

        private static string? ValidatePhotos(CreateDatosRepartidorDto dto)
        {
            const long maxFileSize = 10 * 1024 * 1024;
            var photos = new Dictionary<string, IFormFile?>
            {
                [nameof(dto.FotoCedula)] = dto.FotoCedula,
                [nameof(dto.FotoPerfil)] = dto.FotoPerfil,
                [nameof(dto.RecordPolicial)] = dto.RecordPolicial,
                [nameof(dto.FotoLicencia)] = dto.FotoLicencia
            };

            var allowedContentTypes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "image/jpeg",
                "image/png",
                "image/webp"
            };

            var allowedExtensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                ".jpg",
                ".jpeg",
                ".png",
                ".webp"
            };

            foreach (var photo in photos)
            {
                if (photo.Value is null || photo.Value.Length == 0)
                {
                    return $"La foto '{photo.Key}' es obligatoria y no puede estar vacía.";
                }

                if (photo.Value.Length > maxFileSize)
                {
                    return $"La foto '{photo.Key}' no puede superar los 10 MB.";
                }

                var extension = Path.GetExtension(photo.Value.FileName);
                if (!allowedExtensions.Contains(extension))
                {
                    return $"La foto '{photo.Key}' debe tener formato JPG, JPEG, PNG o WEBP.";
                }

                if (!allowedContentTypes.Contains(photo.Value.ContentType))
                {
                    return $"El tipo MIME de la foto '{photo.Key}' no es válido.";
                }
            }

            return null;
        }

        [HttpPatch("review")]
        [Authorize(Roles = "Administrador")] 
        public async Task<IActionResult> ReviewDeliveryRequest([FromBody] ReviewRequestDto dto, CancellationToken ct)
        {
           
            var result = await _mediator.Send(new ReviewRequestCommand(dto), ct);

          
            return StatusCode(result.StatusCode, result);
        }

        [HttpPatch("review/{id}")]
        [Authorize(Roles = "Administrador")]
        public async Task<IActionResult> ReviewDeliveryRequestById([FromRoute] int id, [FromBody] ReviewRequestDto dto, CancellationToken ct)
        {
            if (id <= 0)
            {
                return BadRequest("Id Invalido");
            }
            var result = await _mediator.Send(new ReviewRequestByIdCommand(id, dto), ct);
            return StatusCode(result.StatusCode, result);
        }

    }
}
