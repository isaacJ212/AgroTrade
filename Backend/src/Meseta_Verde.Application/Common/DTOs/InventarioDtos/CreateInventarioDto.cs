using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.InventarioDtos
{
    public class CreateInventarioDto
    {
        [Required] public int IdProveedor { get; set; }
        [Required] public int IdProducto { get; set; }
        [Required] public float StockActual { get; set; }
        [Required] public decimal CostoProduccion { get; set; }
        [Required] public decimal PrecioVenta { get; set; }
        public bool EsOfertaExcedente { get; set; } = false;
        public float? PorcentajeDescuento { get; set; }
        public DateTime? FechaCosecha { get; set; }
    }
}