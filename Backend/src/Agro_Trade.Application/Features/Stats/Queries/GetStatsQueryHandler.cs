using Agro_Trade.Application.Common;
using MediatR;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace Agro_Trade.Application.Features.Stats.Queries
{
    public class GetStatsQueryHandler : IRequestHandler<GetStatsQuery, Result<object>>
    {
        public Task<Result<object>> Handle(GetStatsQuery request, CancellationToken cancellationToken)
        {
            var mockStats = new
            {
                TotalUsuarios = 150,
                TotalVentas = 5000,
                ActividadesRecientes = new List<object>
                {
                    new { Mensaje = "Nuevo usuario registrado", Fecha = System.DateTime.UtcNow },
                    new { Mensaje = "Pedido completado", Fecha = System.DateTime.UtcNow.AddMinutes(-5) }
                }
            };
            
            return Task.FromResult(Result<object>.Success(200, mockStats, "Success", true));
        }
    }
}
