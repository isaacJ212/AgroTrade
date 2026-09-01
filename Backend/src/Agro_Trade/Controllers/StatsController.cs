using Agro_Trade.Application.Common;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading;
using System.Threading.Tasks;
using Agro_Trade.Application.Features.Stats.Queries;

namespace Agro_Trade.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Administrador")]
    public class StatsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public StatsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<IActionResult> Get(CancellationToken ct)
        {
            var result = await _mediator.Send(new GetStatsQuery(), ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, new { ErrorMessage = result.Message });
        }
    }
}
