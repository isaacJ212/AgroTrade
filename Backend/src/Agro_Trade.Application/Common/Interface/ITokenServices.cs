using Agro_Trade.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.Interface
{
    public interface ITokenServices
    {
        Task<string> GenerateTokenAsync(Usuario usuario);
    }
}
