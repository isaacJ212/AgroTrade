using Agro_Trade.Application.Common;
using MediatR;
using System.Collections.Generic;

namespace Agro_Trade.Application.Features.Stats.Queries
{
    public class GetStatsQuery : IRequest<Result<object>>
    {
    }
}
