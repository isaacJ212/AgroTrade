using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.InventarioDtos
{
    public class PatchInventarioDto
    {
        public int? IdProveedor { get; set; }
        
        public int? IdProducto { get; set; }
        
        [Range(0, float.MaxValue, ErrorMessage = "El stock no puede ser negativo.")]
        public float? StockActual { get; set; }
        
        [Range(0.01, double.MaxValue, ErrorMessage = "El costo debe ser mayor a 0.")]
        public decimal? CostoProduccion { get; set; }
        
        [Range(0.01, double.MaxValue, ErrorMessage = "El precio de venta debe ser mayor a 0.")]
        public decimal? PrecioVenta { get; set; }
        
        public bool? EsOfertaExcedente { get; set; }
        
        public float? PorcentajeDescuento { get; set; }
        
        public DateTime? FechaCosecha { get; set; }
        
        public bool? Disponible { get; set; }
    }
}