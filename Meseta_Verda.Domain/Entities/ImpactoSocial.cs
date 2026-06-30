using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class ImpactoSocial
    {
        [Key]
        public int IdImpacto { get; set; }
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;
        
        public float KgCarbonoReducido { get; set; }
        public float ApoyoEconomicoLocal { get; set; } 
        public string? DescripcionLogro { get; set; }
    }
}