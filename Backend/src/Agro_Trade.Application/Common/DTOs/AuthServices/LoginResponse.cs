using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.DTOs.TokensDtos;

namespace Agro_Trade.Application.Common.DTOs.AuthServices
{
    public class LoginResponse
    {
        public string UserName { get; set; }
        public TokensResponse TokenResponse { get; set; }
        public List<String> Roles {get;set;} = new();
        public bool RequiereCompletarInformacion { get; set; } = true;

    }
}
