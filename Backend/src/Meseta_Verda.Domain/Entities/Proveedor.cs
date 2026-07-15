using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class Proveedor
    {
        [Key]
        public int IdProveedor { get; set; }
        
        public int IdUsuario { get; set; }
        public Usuario Usuario { get; set; } = null!; 

        [Required]
        [MaxLength(150)]
        public string NombreProveedor { get; set; } = null!;
        
        [MaxLength(150)]
        public string? NombreFinca { get; set; }
        
        public string? UbicacionGps { get; set; }
        
        public string? Biografia { get; set; }
        
        public float? CalificacionPromedio { get; set; }

       
        public ICollection<Producto> Productos { get; set; } = new List<Producto>();
        public ICollection<InventarioProveedor> Inventarios { get; set; } = new List<InventarioProveedor>();
        public ICollection<ImpactoSocial> ImpactosSociales { get; set; } = new List<ImpactoSocial>();
    }
}