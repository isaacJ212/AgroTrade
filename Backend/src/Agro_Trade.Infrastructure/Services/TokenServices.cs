using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Agro_Trade.Application.Features.ImpactoSocial.Queries;

namespace Agro_Trade.Infrastructure.Services
{
    public class TokenServices : ITokenServices
    {
        private readonly string RefreshTokenIdClaimType = "refresh_token_id";
        private readonly IUnitofWork _unitOfWork;
        private readonly IConfiguration _configuration;

        
        public TokenServices(IUnitofWork unitOfWork, IConfiguration configuration)
        {
            _unitOfWork = unitOfWork;
            _configuration = configuration;
        }
        public async Task<string> GenerateTokenAsync(Usuario usuario, Guid  refreshTokenId)
        {
            var claims = new List<Claim>
         {
             new Claim(ClaimTypes.NameIdentifier, usuario.IdUsuario.ToString()),
             new Claim(ClaimTypes.Email, usuario.Email),
             new Claim(ClaimTypes.Name, usuario.NombreCompleto),
             new Claim(RefreshTokenIdClaimType, refreshTokenId.ToString()),
             new Claim(System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
         };
         var roles = await _unitOfWork.Users.GetRolesByUserIdAsync(usuario.IdUsuario, CancellationToken.None);
         foreach (var role in roles)
         {
             claims.Add(new Claim(ClaimTypes.Role, role));
           }
         var configuredKey = _configuration["Jwt:Key"] ?? _configuration["Jwt:SigninKey"];
         if (string.IsNullOrWhiteSpace(configuredKey))
             throw new InvalidOperationException("Falta configurar Jwt:Key o Jwt:SigninKey.");

         var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuredKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);


        }

        // FUENTE PARA APRENDER REFRESH TOKEN STOCKITAPI POR DANNY LOPEZ
        public string ComputeHash(string raw)
        {
            var hashed = SHA256.HashData(Encoding.UTF8.GetBytes(raw));
            return Convert.ToBase64String(hashed);
        }

        public RefreshTokenResult GenerateRefreshToken()
        {
            //hasheamos el token
            var bytes = RandomNumberGenerator.GetBytes(64);
            var rawToken = Convert.ToBase64String(bytes);
            var hash = ComputeHash(rawToken);
            
            //obtenemos la expiracion
            if (!int.TryParse(_configuration["Jwt:RefreshTokenDays"], out int days)) days = 30;
            DateTimeOffset expiresAt = DateTime.UtcNow.AddDays(days);

            return new RefreshTokenResult(rawToken, hash, expiresAt.UtcDateTime);

        }

    }
}
