using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class Permiso
    {
        [Key]
        public int IdPermiso { get; set; }
        public string NombrePermiso { get; set; }
        
        public ICollection<RolPermiso> RolesPermisos { get; set; } = new List<RolPermiso>();
    }
    
}