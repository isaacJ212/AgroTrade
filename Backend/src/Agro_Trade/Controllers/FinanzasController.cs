using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.FinanzasDtos;
using Agro_Trade.Application.Features.Finanzas.Queries;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/finanzas")]
    [Authorize]
    public class FinanzasController(IMediator mediator) : ControllerBase
    {
        [HttpGet("auditoria-ach")]
        public async Task<ActionResult<Result<List<RegistroTransferenciaAuditoriaDto>>>> GetAuditoriaAch()
        {
            var result = await mediator.Send(new GetDashboardAuditoriaACHQuery());
            return StatusCode(result.StatusCode, result);
        }
    }
}
