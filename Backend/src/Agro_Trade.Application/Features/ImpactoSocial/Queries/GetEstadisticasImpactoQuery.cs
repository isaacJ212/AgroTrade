using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ImpactoSocialDtos;
using Agro_Trade.Application.Common.Interface;



namespace Agro_Trade.Application.Features.ImpactoSocial.Queries
{
    public record GetEstadisticasImpactoQuery(DateTime FechaInicio, DateTime FechaFin) : IRequest<Result<List<EstadisticaImpactoDto>>>;

    public class GetEstadisticasImpactoQueryHandler : IRequestHandler<GetEstadisticasImpactoQuery, Result<List<EstadisticaImpactoDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetEstadisticasImpactoQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<EstadisticaImpactoDto>>> Handle(GetEstadisticasImpactoQuery request, CancellationToken cancellationToken)
        {
            if (request.FechaInicio > request.FechaFin)
                return Result<List<EstadisticaImpactoDto>>.Failure(400, "La fecha de inicio no puede ser mayor a la fecha de fin.");

            var impactos = await _unitOfWork.ImpactosSociales.GetAllAsync(cancellationToken);

            if (impactos == null || !impactos.Any())
                return Result<List<EstadisticaImpactoDto>>.Success(200, new List<EstadisticaImpactoDto>(), "Sin datos.", true);

            
            var estadisticas = impactos
                .Where(i => i.Pedido != null && i.Pedido.FechaPedido >= request.FechaInicio && i.Pedido.FechaPedido <= request.FechaFin)
                .GroupBy(i => i.Pedido.FechaPedido.Date)
                .Select(grupo => new EstadisticaImpactoDto
                {
                    Fecha = grupo.Key.ToString("yyyy-MM-dd"),
                    ProductosSalvadosDia = grupo.Sum(i => i.ProductosSalvados),
                    BeneficioGeneradoDia = grupo.Sum(i => i.BeneficioExtraProductor)
                })
                .OrderBy(e => e.Fecha) // Orden cronológico para el gráfico
                .ToList();

            return Result<List<EstadisticaImpactoDto>>.Success(200, estadisticas, "Datos para gráfica generados.", true);
        }

    }
}