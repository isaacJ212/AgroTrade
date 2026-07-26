using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace Meseta_Verda.Domain.Entities
{
    public class Pedido
    {
        [Key]
        public int IdPedido { get; set; }
        
        public int IdUsuarioCliente { get; set; }
        public Usuario UsuarioCliente { get; set; } = null!;
        
        public DateTime FechaPedido { get; set; }
        public decimal Total { get; set; }
        public string? MetodoPago { get; set; }
        public string? EstadoPago { get; set; }
        public string? EstadoEnvio { get; set; }
        
       
        public ICollection<DetallePedido> Detalles { get; set; } = new List<DetallePedido>();
        public ICollection<ImpactoSocial> ImpactosSociales { get; set; } = new List<ImpactoSocial>();
        public ICollection<Valoracion> Valoraciones { get; set; } = new List<Valoracion>();
        public ICollection<RegistroTransferenciaMock> TransferenciasDistribuidas { get; set; } = new List<RegistroTransferenciaMock>();
    }
}
