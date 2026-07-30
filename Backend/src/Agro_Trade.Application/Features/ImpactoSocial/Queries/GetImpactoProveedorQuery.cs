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
    public record GetImpactoProveedorQuery(int IdProveedor) : IRequest<Result<ImpactoProveedorDto>>;

    public class GetImpactoProveedorQueryHandler : IRequestHandler<GetImpactoProveedorQuery, Result<ImpactoProveedorDto>>
    {

        private readonly IUnitofWork _unitOfWork;


        public GetImpactoProveedorQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }


        public async Task<Result<ImpactoProveedorDto>> Handle(GetImpactoProveedorQuery request, CancellationToken cancellationToken)
        {
            if (request.IdProveedor <= 0)
                return Result<ImpactoProveedorDto>.Failure(400, "El ID del proveedor no es válido.");

           
            var impactos = await _unitOfWork.ImpactosSociales.FindAsync(
                i => i.IdProveedor == request.IdProveedor, 
                cancellationToken);

            if (impactos == null || !impactos.Any())
            {
                
                var emptyData = new ImpactoProveedorDto { IdProveedor = request.IdProveedor };
                return Result<ImpactoProveedorDto>.Success(200, emptyData, "El proveedor aún no registra impacto social.", true);
            }

            
            var data = new ImpactoProveedorDto
            {
                IdProveedor = request.IdProveedor,
                ProductosSalvadosKg = impactos.Sum(i => i.ProductosSalvados),
                BeneficioExtraProductor = impactos.Sum(i => i.BeneficioExtraProductor),
                VentasExcedentesLogradas = impactos.Count()
            };

            return Result<ImpactoProveedorDto>.Success(200, data, "Impacto del proveedor calculado con éxito.", true);


        


        }



        
    }
}