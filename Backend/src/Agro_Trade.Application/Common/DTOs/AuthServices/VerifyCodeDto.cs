using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.AuthServices
{
    public class VerifyCodeDto
    {
        [Required]
        public int UserId { get; set; }

        [Required]
        public string Code { get; set; } = string.Empty;
    }
}
