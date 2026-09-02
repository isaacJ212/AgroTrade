using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.BotCommunication
{
    public class BotRequest
    {
        [Required(ErrorMessage = "El campo UserId es obligatorio.")]
        public string UserId { get; set; } = string.Empty;
        [Required(ErrorMessage = "El campo Message es obligatorio.")]
        public string Message { get; set; } = string.Empty;
        [Required(ErrorMessage = "El campo Module es obligatorio.")]
        public string Module { get; set; } = string.Empty;
    }
}