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
    public record GetImpactoGlobalQuery : IRequest<Result<ImpactoSocialGlobalDto>>;


    public class GetImpactoGlobalQueryHandler : IRequestHandler<GetImpactoGlobalQuery, Result<ImpactoSocialGlobalDto>>
    {

        private readonly IUnitofWork _unitOfWork;

        public GetImpactoGlobalQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }


        public async Task<Result<ImpactoSocialGlobalDto>> Handle(GetImpactoGlobalQuery request, CancellationToken cancellationToken)
        {

           
            var impactos = await _unitOfWork.ImpactosSociales.GetAllAsync(cancellationToken);

            if (impactos == null || !impactos.Any())
            {
                return Result<ImpactoSocialGlobalDto>.Success(200, new ImpactoSocialGlobalDto(), "Aún no hay datos de impacto social.", true);
            }

            
            var data = new ImpactoSocialGlobalDto
            {
                TotalProductosSalvados = impactos.Sum(i => i.ProductosSalvados),
                TotalBeneficioExtra = impactos.Sum(i => i.BeneficioExtraProductor),
                ProveedoresBeneficiados = impactos.Select(i => i.IdProveedor).Distinct().Count()
            };

            return Result<ImpactoSocialGlobalDto>.Success(200, data, "Impacto global calculado con éxito.", true);

        }
        
    }
}