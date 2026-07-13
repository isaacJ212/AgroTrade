using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ImpactoSocialDtos;
using Meseta_Verde.Application.Common.Interface;


namespace Meseta_Verde.Application.Features.ImpactoSocial.Queries
{

    public record GetHistorialImpactoQuery(int IdProveedor) : IRequest<Result<List<HistorialImpactoDto>>>;


    public class GetHistorialImpactoQueryHandler : IRequestHandler<GetHistorialImpactoQuery, Result<List<HistorialImpactoDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetHistorialImpactoQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<HistorialImpactoDto>>> Handle(GetHistorialImpactoQuery request, CancellationToken cancellationToken)
        {


          
            if (request.IdProveedor <= 0)
                return Result<List<HistorialImpactoDto>>.Failure(400, "El ID del proveedor es inválido.");



            var impactos = await _unitOfWork.ImpactosSociales.FindAsync(
                i => i.IdProveedor == request.IdProveedor, 
                cancellationToken);

            if (impactos == null || !impactos.Any())
            {
                return Result<List<HistorialImpactoDto>>.Success(200, new List<HistorialImpactoDto>(), "No hay historial de impacto registrado.", true);
            }


           
           
            var historial = impactos.Select(i => new HistorialImpactoDto
            {
                IdImpacto = i.IdImpacto,
                // Asumimos que la navegación hacia Pedido está disponible para extraer la fecha
                FechaVenta = i.Pedido?.FechaPedido ?? DateTime.UtcNow, 
                ProductosSalvadosKg = i.ProductosSalvados,
                BeneficioGenerado = i.BeneficioExtraProductor
            })
            .OrderByDescending(h => h.FechaVenta)
            .ToList();

            return Result<List<HistorialImpactoDto>>.Success(200, historial, "Historial obtenido con éxito.", true);



        }
    }
}