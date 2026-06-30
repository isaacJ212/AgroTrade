using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class Categoria
    {
        [Key]
        public int IdCategoria { get; set; }
        
        [Required]
        [MaxLength(100)]
        public string Nombre { get; set; } = null!;
        
        public ICollection<Producto> Productos { get; set; } = new List<Producto>();
    }
}