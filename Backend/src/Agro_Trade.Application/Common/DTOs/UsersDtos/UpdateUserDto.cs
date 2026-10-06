using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.UsersDtos
{
    public class UpdateUserDto
    {
        public string? Nombres { get; set; }
        public string? Apellidos { get; set; }
        
        public string? Email { get; set; }

        [RegularExpression(@"^[578]\d{7}$", ErrorMessage = "El numero debe tener 8 digitos y comenzar con 5, 7 u 8.")]
        public string? Telefono { get; set; }
        [MaxLength(200, ErrorMessage = "La Direccion no debe sobrepasar los 200 caracteres")]
        public string? DireccionBase
        {
            get; set;
        }
        [MaxLength(30, ErrorMessage = "El Departamento no debe sobrepasar los 30 caracteres ")]
        public string? Departamento { get; set; }
        [MaxLength(30, ErrorMessage = "El Municipio no debe sobrepasar los 30 caracteres ")]
        public string? Municipio { get; set; }
    }
}
