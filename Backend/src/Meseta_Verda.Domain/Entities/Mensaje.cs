using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace Meseta_Verda.Domain.Entities
{
    public class Mensaje
    {
        [Key]
        public int IdMensaje { get; set; }
        public int IdConversacion { get; set; }
        public Conversacion Conversacion { get; set; } = null!;
        
        public int IdUsuarioEmisor { get; set; }
        public Usuario Emisor { get; set; } = null!;
        
        public string Contenido { get; set; } = null!;
        public DateTime EnviadoEn { get; set; } = DateTime.UtcNow;
        public bool Leido { get; set; } = false;
    }
}