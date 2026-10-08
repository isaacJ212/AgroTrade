using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

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

        public int IdUnidadDeMedida { get; set; }
        [ForeignKey("IdUnidadDeMedida")]

        public UnidadDeMedida UnidadDeMedida { get; set; } = null!;


        public Categoria Categoria { get; set; } = null!;
        public Proveedor Proveedor { get; set; } = null!;


        public ICollection<InventarioProveedor> Inventarios { get; set; } = new List<InventarioProveedor>();

    }
}