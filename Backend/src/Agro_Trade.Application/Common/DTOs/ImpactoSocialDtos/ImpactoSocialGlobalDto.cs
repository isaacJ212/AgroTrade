using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ImpactoSocialDtos
{
    public class ImpactoSocialGlobalDto
    {
        public float TotalProductosSalvados { get; set; }
        public float TotalBeneficioExtra { get; set; }
        public int ProveedoresBeneficiados { get; set; }
    }
}