using Meseta_Verda.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.Interface
{
    public interface ITokenServices
    {
        Task<string> GenerateTokenAsync(Usuario usuario);
    }
}
