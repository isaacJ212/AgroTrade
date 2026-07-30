using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.InventarioDtos
{
    public class InventarioDtos
    {
        public int IdInventario { get; set; }
        public int IdProveedor { get; set; }
        public int IdProducto { get; set; }
        public string? FotoUrl { get; set; }
        public string? VideoUrl { get; set; }
        public float StockActual { get; set; }
        public decimal CostoProduccion { get; set; }
        public decimal PrecioVenta { get; set; }
        public bool EsOfertaExcedente { get; set; }
        public float? PorcentajeDescuento { get; set; }
        public DateTime? FechaCosecha { get; set; }
        public bool Disponible { get; set; }
    }
}