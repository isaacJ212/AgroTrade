using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.ConversacionesDtos
{
    public class MensajeDto
    {
        public int IdMensaje { get; set; }
        public int IdConversacion { get; set; }
        public int IdUsuarioEmisor { get; set; }
        public string NombreEmisor { get; set; } = string.Empty;
        public string Contenido { get; set; } = string.Empty;
        public DateTime EnviadoEn { get; set; }
        public bool Leido { get; set; }
    }
}