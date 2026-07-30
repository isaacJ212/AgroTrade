using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles
{
    public class ReviewRequestDto
    {
        [Required(ErrorMessage ="El estado de la solicitud es requerido")]
        
        public int Estado { get; set; } // 1: Aprobado, 2: Rechazado
        [Required(ErrorMessage ="El comentario es requerido")]
        public string Comentario { get; set; } = string.Empty;

    }
}
