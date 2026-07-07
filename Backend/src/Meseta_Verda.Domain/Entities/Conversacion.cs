using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace Meseta_Verda.Domain.Entities
{
    public class Conversacion
    {
        [Key]
        public int IdConversacion { get; set; }
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;
        public DateTime CreadaEn { get; set; } = DateTime.UtcNow;
        
        // Navegación
        public ICollection<ConversacionParticipante> Participantes { get; set; } = new List<ConversacionParticipante>();
        public ICollection<Mensaje> Mensajes { get; set; } = new List<Mensaje>();
    }
}