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

namespace Agro_Trade.Application.Features.Auth
{
    public record GoogleSignInCommand(OAuthSignInDto dto) : IRequest<Result<LoginResponse>>;
    public class GoogleSignInHandler : IRequestHandler<GoogleSignInCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly ITokenServices _tokenServices;
        private readonly IConfiguration _configuration;
        private readonly IRepository<UsuarioRol> _roles;
        public GoogleSignInHandler(IUnitofWork unitOfWork, ITokenServices tokenServices, IConfiguration configuration, IRepository<UsuarioRol> roles)
        {
            _unitOfWork = unitOfWork;
            _tokenServices = tokenServices;
            _configuration = configuration;
            _roles = roles;
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
                    IdentidadVerificada = false
                };
                await _unitOfWork.Users.AddAsync(user, cancellationToken);
                await _unitOfWork.SaveChangesAsync(cancellationToken);
                //Rol Predeterminado que es el de cliente
                await _roles.AddAsync(new UsuarioRol { IdUsuario = user.IdUsuario, IdRol = 1 }, cancellationToken);
                await _unitOfWork.SaveChangesAsync(cancellationToken);

               
            }
            var jwtToken = await _tokenServices.GenerateTokenAsync(user);

            return Result<LoginResponse>.Success(200, new LoginResponse { UserName = user.NombreCompleto, Token = jwtToken }, "Usuario Registrado Con Google Exitosamente", true);
        }
    }
}