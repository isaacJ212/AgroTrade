using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class Producto
    {
        [Key]
        public int IdProducto { get; set; }
        
       
        public int IdCategoria { get; set; }
        public int IdProveedor { get; set; }
        
   
        [Required]
        [MaxLength(200)]
        public string Nombre { get; set; } = null!;
        
        public string? Descripcion { get; set; }
        
        [Required]
        [MaxLength(50)]
        public string UnidadMedida { get; set; } = null!;

        // Jafet: Se agregó esta propiedad para hacer el borrado lógico (Soft Delete) de los productos
        public bool Activo { get; set; } = true;

       
        public Categoria Categoria { get; set; } = null!;
        public Proveedor Proveedor { get; set; } = null!;
        
      
        public ICollection<InventarioProveedor> Inventarios { get; set; } = new List<InventarioProveedor>();
        
    }
}