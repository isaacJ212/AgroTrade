using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verda.Domain.Entities
{
    public class ConversacionParticipante
    {
        public int IdConversacion { get; set; }
        public Conversacion Conversacion { get; set; } = null!;
        
        public int IdUsuario { get; set; }
        public Usuario Usuario { get; set; } = null!;
    }
}