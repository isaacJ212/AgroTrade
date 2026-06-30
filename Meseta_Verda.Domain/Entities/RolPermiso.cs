using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verda.Domain.Entities
{
    public class RolPermiso
    {
        public int IdRol { get; set; }
        public Rol Rol { get; set; } = null!;

        public int IdPermisos { get; set; }
        public Permiso Permiso { get; set; }
    }
}