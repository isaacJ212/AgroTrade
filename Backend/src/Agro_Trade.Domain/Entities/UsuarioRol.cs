using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Domain.Entities
{
    public class UsuarioRol
    {
        public int IdUsuario { get; set; }
        public Usuario Usuario { get; set; }

        public int IdRol { get; set; }
        public Rol Rol { get; set; }
    }
}