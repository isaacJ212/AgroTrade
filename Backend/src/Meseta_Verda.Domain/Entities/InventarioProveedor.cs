using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class InventarioProveedor
    {
        [Key]
        public int IdInventario { get; set; }
        
        public int IdProveedor { get; set; }
        public int IdProducto { get; set; }
        
        public string? FotoUrl { get; set; }
        public string? VideoUrl { get; set; }
        
        public float StockActual { get; set; }
        public decimal CostoProduccion { get; set; }
        public decimal PrecioVenta { get; set; }
        
        public bool EsOfertaExcedente { get; set; } = false;
        public float? PorcentajeDescuento { get; set; }
        public DateTime? FechaCosecha { get; set; }
        public bool Disponible { get; set; } = true;

      
        public Proveedor Proveedor { get; set; } = null!;
        public Producto Producto { get; set; } = null!;
        
       
        public ICollection<DetallePedido> DetallesPedido { get; set; } = new List<DetallePedido>();
    }
}