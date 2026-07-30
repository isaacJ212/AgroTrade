using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ImpactoSocialDtos
{
    public class ImpactoProveedorDto
    {
        public int IdProveedor { get; set; }
        public float ProductosSalvadosKg { get; set; }
        public float BeneficioExtraProductor { get; set; }
        public int VentasExcedentesLogradas { get; set; }
    }
}