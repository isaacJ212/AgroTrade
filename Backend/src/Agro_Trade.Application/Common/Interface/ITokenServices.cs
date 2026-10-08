using Agro_Trade.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.DTOs.TokensDtos;

namespace Agro_Trade.Application.Common.Interface
{
    public interface ITokenServices
    {
        Task<string> GenerateTokenAsync(Usuario usuario, Guid refreshTokenId);
        RefreshTokenResult  GenerateRefreshToken();
        string ComputeHash(string raw);
    }
}
