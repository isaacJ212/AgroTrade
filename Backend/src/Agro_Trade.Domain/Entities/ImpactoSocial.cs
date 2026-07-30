using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class ImpactoSocial
    {
        [Key]
        public int IdImpacto { get; set; }
        public int IdProveedor { get; set; }
        public Proveedor Proveedor { get; set; } = null!;
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;
        public int IdDetallePedido { get; set; }
        public DetallePedido DetallePedido { get; set; } = null!;

        public DateTime FechaRegistro { get; set; } = DateTime.UtcNow;
        public float ProductosSalvados { get; set; }
        public float BeneficioExtraProductor { get; set; }
    }
}