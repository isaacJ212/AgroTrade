using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.AuthServices
{
    public class LoginResponse
    {
        public string UserName { get; set; }
        public string Token { get; set; }
        public List<String> Roles {get;set;} = new();
        
    }
}
