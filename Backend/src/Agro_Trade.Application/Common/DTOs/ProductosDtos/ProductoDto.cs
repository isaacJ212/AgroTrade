using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ProductosDtos
{
    public class ProductoDto
    {
        public int IdProducto { get; set; }
        public int IdCategoria { get; set; }
        public int IdProveedor { get; set; }
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public string? UnidadMedida { get; set; }

        
    }
}