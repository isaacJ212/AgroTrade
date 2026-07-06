using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.UsersDtos
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public bool IdentidadVerificada { get; set; }
        public string? Telefono { get; set; }
        public string? DireccionBase { get; set; }
        public DateTime? FechaRegistro { get; set; }
    }
}
