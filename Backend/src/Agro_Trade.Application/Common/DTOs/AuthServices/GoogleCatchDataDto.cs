using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.AuthServices;

public class GoogleCatchDataDto
{
    
    [Required(ErrorMessage = "El departamento es obligatorio.")]
    [MaxLength(100, ErrorMessage = "El nombre del departamento no puede exceder los 100 caracteres.")]
    public string Departamento { get; set; } = string.Empty;

    [Required(ErrorMessage = "El Municipio es obligatorio.")]
    [MaxLength(100)]
    public string Municipio { get; set; } = string.Empty;

    [Required(ErrorMessage = "La dirección exacta es obligatoria.")]
    [MaxLength(500, ErrorMessage = "La dirección no puede exceder los 500 caracteres.")]
    public string DireccionExacta { get; set; } = string.Empty;

    [Required(ErrorMessage = "El número de teléfono es obligatorio.")]
    [MaxLength(8, ErrorMessage = "El teléfono no puede exceder los 8 caracteres.")]
    [Phone(ErrorMessage = "El formato del número de teléfono no es válido.")]
    public string Telefono { get; set; } = string.Empty;
}