using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.ConversacionesDtos
{
    public class SendMessageDto
    {
        [Required(ErrorMessage = "El ID de la conversación es obligatorio.")]
        public int IdConversacion { get; set; }

        [Required(ErrorMessage = "El ID del emisor es obligatorio.")]
        public int IdUsuarioEmisor { get; set; }

        [Required(ErrorMessage = "El contenido del mensaje no puede estar vacío.")]
        [MaxLength(1000, ErrorMessage = "El mensaje es demasiado largo.")]
        public string Contenido { get; set; } = string.Empty;
    }
}