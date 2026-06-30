using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class Valoracion
    {
        [Key]
        public int IdValoracion { get; set; }
        public int IdUsuario { get; set; }
        public Usuario Usuario { get; set; } = null!;
        
        public int IdProveedor { get; set; }
        public Proveedor Proveedor { get; set; } = null!;
        
        [Range(1, 5)]
        public int Estrellas { get; set; }
        public string? Comentario { get; set; }
        public DateTime Fecha { get; set; } = DateTime.UtcNow;
    }
}