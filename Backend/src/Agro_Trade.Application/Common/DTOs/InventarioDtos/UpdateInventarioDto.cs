using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.InventarioDtos
{
    public class UpdateInventarioDto
    {
        [Required(ErrorMessage = "El ID del proveedor es obligatorio.")]
        public int IdProveedor { get; set; }
        
        [Required(ErrorMessage = "El ID del producto es obligatorio.")]
        public int IdProducto { get; set; }
        
        [Required(ErrorMessage = "El stock actual es obligatorio.")]
        [Range(0, float.MaxValue, ErrorMessage = "El stock no puede ser negativo.")]
        public float StockActual { get; set; }
        
        [Required(ErrorMessage = "El costo de producción es obligatorio.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El costo debe ser mayor a 0.")]
        public decimal CostoProduccion { get; set; }
        
        [Required(ErrorMessage = "El precio de venta es obligatorio.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El precio de venta debe ser mayor a 0.")]
        public decimal PrecioVenta { get; set; }
        
        public bool EsOfertaExcedente { get; set; } = false;
        
        public float? PorcentajeDescuento { get; set; }
        
        public DateTime? FechaCosecha { get; set; }
        
        public bool Disponible { get; set; } = true;

    }
}