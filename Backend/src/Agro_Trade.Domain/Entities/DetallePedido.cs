using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class DetallePedido
    {
        [Key]
        public int IdDetallePedido { get; set; }
        
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;
        
        public int IdInventario { get; set; }
        public InventarioProveedor Inventario { get; set; } = null!;
        
        public float Cantidad { get; set; }
        public float PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
        public ImpactoSocial? ImpactoSocial { get; set; }
    }
}