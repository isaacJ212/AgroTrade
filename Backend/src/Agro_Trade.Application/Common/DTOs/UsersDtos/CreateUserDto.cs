using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.UsersDtos
{
    public class CreateUserDto
    {
        [Required(ErrorMessage = "El nombre es obligatorio")]
        [MinLength(15, ErrorMessage ="El Nombre Completo requiere mas de 15 Caracteres")]
        public string NombreCompleto { get; set; }

        [Required(ErrorMessage = "El email es obligatorio")]
        [EmailAddress(ErrorMessage = "Formato de email invlido")]
        public string Email { get; set; }

        [Required(ErrorMessage = "La contrasea es obligatoria")]
        [MinLength(6, ErrorMessage = "La contrasea debe tener al menos 6 caracteres")]
        public string Password { get; set; }
        
        // Nuevos campos opcionales
        [StringLength(8)]
        [RegularExpression(@"^[578]\d{7}$", ErrorMessage = "El nmero debe tener 8 dgitos y comenzar con 5, 7 u 8.")]
        public string? Telefono { get; set; }
       
        [MaxLength(200, ErrorMessage = "La Direccion no debe sobrepasar los 200 caracteres")]
        public string? DireccionBase { get; set; }
        
        [MaxLength(30, ErrorMessage = "El Departamento no debe sobrepasar los 30 caracteres ")]
        public string? Departamento { get; set; }

        public int? IdRol { get; set; }
    }
}
