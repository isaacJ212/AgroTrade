using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class Rol
    {
        [Key]
        public int IdRol { get; set; }
        
        [Required]
        [MaxLength(100)]
        public string NombreRol { get; set; } = null!;

        
        public virtual ICollection<UsuarioRol> UsuariosRoles { get; set; } = new List<UsuarioRol>();
        
        
        public virtual ICollection<RolPermiso> RolesPermisos { get; set; } = new List<RolPermiso>();
    }
}