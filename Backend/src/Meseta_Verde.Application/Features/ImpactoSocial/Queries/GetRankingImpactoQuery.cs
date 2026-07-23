using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ImpactoSocialDtos;
using Meseta_Verde.Application.Common.DTOs.InventarioDtos;
using Meseta_Verde.Application.Common.Interface;




namespace Meseta_Verde.Application.Features.ImpactoSocial.Queries
{
    public record GetRankingImpactoQuery(int Top = 5) : IRequest<Result<List<RankingProveedorDto>>>;

    public class GetRankingImpactoQueryHandler : IRequestHandler<GetRankingImpactoQuery, Result<List<RankingProveedorDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetRankingImpactoQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }


        public async Task<Result<List<RankingProveedorDto>>> Handle(GetRankingImpactoQuery request, CancellationToken cancellationToken)
        {
            
            var todosLosImpactos = await _unitOfWork.ImpactosSociales.GetAllAsync(cancellationToken);


            if (todosLosImpactos == null || !todosLosImpactos.Any())
            {
                return Result<List<RankingProveedorDto>>.Success(200, new List<RankingProveedorDto>(), "No hay datos suficientes para el ranking.", true);
            }



            // Agrupamos por Proveedor, sumamos el impacto y ordenamos de mayor a menor
            var ranking = todosLosImpactos
                .GroupBy(i => new { i.IdProveedor, i.Proveedor?.NombreProveedor })
                .Select(grupo => new 
                {
                    grupo.Key.IdProveedor,
                    NombreProveedor = grupo.Key.NombreProveedor ?? "Agricultor Anónimo",
                    TotalSalvado = grupo.Sum(i => i.ProductosSalvados)
                })
                .OrderByDescending(r => r.TotalSalvado)
                .Take(request.Top)
                .ToList();




            // se le asigna la posición 
            var resultadoFinal = ranking.Select((r, index) => new RankingProveedorDto
            {
                Posicion = index + 1,
                IdProveedor = r.IdProveedor,
                NombreProveedor = r.NombreProveedor,
                TotalProductosSalvados = r.TotalSalvado
            }).ToList();

            

            return Result<List<RankingProveedorDto>>.Success(200, resultadoFinal, $"Top {request.Top} generado con éxito.", true);

            
        }
    }
}