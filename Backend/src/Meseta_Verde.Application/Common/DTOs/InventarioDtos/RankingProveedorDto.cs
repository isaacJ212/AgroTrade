using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.InventarioDtos
{
    public class RankingProveedorDto
    {
        public int Posicion { get; set; }
        public int IdProveedor { get; set; }
        public string? NombreProveedor { get; set; }
        public float TotalProductosSalvados { get; set; }
    }
}