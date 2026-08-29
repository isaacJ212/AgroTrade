using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace Agro_Trade.Domain.Entities
{
    public class LogisticaEntrega
    {
        [Key]
        public int IdEntrega { get; set; }
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;
        public int IdUsuarioRepartidor { get; set; }
        public Usuario UsuarioRepartidor { get; set; } = null!;
        
        public string? EstadoActual { get; set; } 
        public string? UbicacionActual { get; set; }
        public DateTime? FechaEstimada { get; set; }
        public DateTime? FechaEntregaReal { get; set; }
    }
}