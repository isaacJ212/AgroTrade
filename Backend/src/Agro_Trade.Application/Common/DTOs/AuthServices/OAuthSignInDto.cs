using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.AuthServices
{
    public class OAuthSignInDto
    {
        [Required(ErrorMessage = "El token de Autenticación es obligatorio.")]
        public string IdToken { get; set; }
    }
}
