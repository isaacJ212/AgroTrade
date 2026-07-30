using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ImpactoSocialDtos
{
    public class HistorialImpactoDto
    {
        public int IdImpacto { get; set; }
        public DateTime FechaVenta { get; set; }
        public float ProductosSalvadosKg { get; set; }
        public float BeneficioGenerado { get; set; }
        
    }
}