using Google.Apis.Auth;
using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.Interface;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Google.Apis.Auth.OAuth2.Responses;

namespace Agro_Trade.Application.Features.Auth
{
    public record GoogleSignInCommand(OAuthSignInDto dto) : IRequest<Result<LoginResponse>>;
    public class GoogleSignInHandler : IRequestHandler<GoogleSignInCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly ITokenServices _tokenServices;
        private readonly IConfiguration _configuration;
        private readonly IRepository<UsuarioRol> _roles;
        private readonly IRepository<RefreshToken> _refreshTokens;
        private readonly IAppContext _appContext;
        public GoogleSignInHandler(IUnitofWork unitOfWork, ITokenServices tokenServices, IConfiguration configuration, IRepository<UsuarioRol> roles,IRepository<RefreshToken> refreshTokens, IAppContext appContext)
        {
            _unitOfWork = unitOfWork;
            _tokenServices = tokenServices;
            _configuration = configuration;
            _roles = roles;
            _appContext = appContext;
            _refreshTokens = refreshTokens;
        }

        public async Task<Result<LoginResponse>> Handle(GoogleSignInCommand request, CancellationToken cancellationToken)
        {
            GoogleJsonWebSignature.Payload payload;

            try
            {
                payload = await GoogleJsonWebSignature.ValidateAsync(request.dto.IdToken, new GoogleJsonWebSignature.ValidationSettings
                {
                    Audience = new List<string> { _configuration["Google:ClientId"] }
                });
               
            }
            catch (Exception)
            {
                return Result<LoginResponse>.Failure(403, "Invalid Google token.");
            }

            var user = await _unitOfWork.Users.GetByEmailAsync(payload.Email, cancellationToken);
            if (user == null)
            {
                user = new Agro_Trade.Domain.Entities.Usuario
                {
                    NombreCompleto = payload.Name,
                    Email = payload.Email,
                    OAuthProvider = "Google",
                    OAuthProviderId = payload.Subject,
                    IdentidadVerificada = false,
                    FechaRegistro = DateTime.Now,
                };
                await _unitOfWork.Users.AddAsync(user, cancellationToken);
                await _unitOfWork.SaveChangesAsync(cancellationToken);
                //Si no pasa el rol se asigna el de cliente 
                await _roles.AddAsync(new UsuarioRol { IdUsuario = user.IdUsuario, IdRol = request.dto.idRol?? 1 }, cancellationToken);
                await _unitOfWork.SaveChangesAsync(cancellationToken);

               
            }
            //CAMBIOS PARA LA GENERACION DE RefreshToken
            var token = _tokenServices.GenerateRefreshToken();

            RefreshToken refreshToken = new()
            {
                Id = Guid.NewGuid(),
                UserId = user.IdUsuario,
                ExpiresAt = token.ExpiresAtUtc,
                CreatedAt = DateTime.UtcNow,
                Hash = token.HashedToken,
                CreatedByIp = _appContext.IpAdress,
            };
            var jwtToken = await _tokenServices.GenerateTokenAsync(user, refreshToken.Id);
            await _refreshTokens.AddAsync(refreshToken, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);
            
            bool faltanDatos = string.IsNullOrEmpty(user.Departamento)||string.IsNullOrEmpty(user.DireccionBase) || string.IsNullOrEmpty(user.Telefono);
            
             var roles = await _roles.FindAsync(r=> r.IdUsuario == user.IdUsuario,cancellationToken, "Rol");
            var stringList = roles
                            .Where(r => r.Rol != null)
                            .Select(r => r.Rol.NombreRol)
                            .ToList();

            return Result<LoginResponse>.Success(200, new LoginResponse { UserName = user.NombreCompleto, TokenResponse = new TokensResponse(jwtToken, token.RawToken, token.ExpiresAtUtc), Roles= stringList, RequiereCompletarInformacion = faltanDatos}, "Usuario Registrado Con Google Exitosamente", true);
        }
    }
}