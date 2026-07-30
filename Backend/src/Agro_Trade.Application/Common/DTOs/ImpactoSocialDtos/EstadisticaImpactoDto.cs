using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ImpactoSocialDtos
{
    public class EstadisticaImpactoDto
    {
        
        public string Fecha { get; set; } = string.Empty;
        public float ProductosSalvadosDia { get; set; }
        public float BeneficioGeneradoDia { get; set; }
    }
}