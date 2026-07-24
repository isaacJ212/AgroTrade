using Meseta_Verda.Domain.Events;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verda.Domain.Entities
{
   
    public class SolicitudRepartidor
    {
        [Key]
        public int IdSolicitud { get; set; }
        [Required]
        public int IdUsuario { get; set; }
        [ForeignKey("IdUsuario")]
        public Usuario Usuario { get; set; } = null!;
        // Aquí está el truco: se mapea como columna tipo jsonb
        [Column("datos_repartidor", TypeName = "jsonb")]
        public  DatosRepartidorDto DatosRepartidor { get; set; } = new();
        [StringLength(20)]
        public string Estado { get; set; } = "pendiente";

        public DateTime FechaSolicitud { get; set; } = DateTime.UtcNow;

       

    }
}
