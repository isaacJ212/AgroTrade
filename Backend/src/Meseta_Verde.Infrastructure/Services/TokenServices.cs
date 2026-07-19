using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common.Interface;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.Services
{
    public class TokenServices : ITokenServices
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IConfiguration _configuration;
        public TokenServices(IUnitofWork unitOfWork, IConfiguration configuration)
        {
            _unitOfWork = unitOfWork;
            _configuration = configuration;
        }
        public async Task<string> GenerateTokenAsync(Usuario usuario)
        {
            var claims = new List<Claim>
         {
             new Claim(ClaimTypes.NameIdentifier, usuario.IdUsuario.ToString()),
             new Claim(ClaimTypes.Email, usuario.Email),
             new Claim(ClaimTypes.Name, usuario.NombreCompleto),
             new Claim(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
         };
         var roles = await _unitOfWork.Users.GetRolesByUserIdAsync(usuario.IdUsuario, CancellationToken.None);
         foreach (var role in roles)
         {
             claims.Add(new Claim(ClaimTypes.Role, role));
           }
         var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddDays(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);


        }
    }
}
