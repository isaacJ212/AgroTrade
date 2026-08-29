using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ImpactoSocialDtos
{
    public class RankingProveedorDto
    {
        public int Posicion { get; set; }
        public int IdProveedor { get; set; }
        public string? NombreProveedor { get; set; }
        public float TotalProductosSalvados { get; set; }
    }
}