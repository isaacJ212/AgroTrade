using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.UsersDtos
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public bool IdentidadVerificada { get; set; }
        public string? Telefono { get; set; }
        public string? DireccionBase { get; set; }
        public string? Departamento { get; set; }
        public string EstadoCuenta { get; set; }
        public DateTime? FechaRegistro { get; set; }
        public List<string> Roles { get; set; } = new List<string>();

    }
}
