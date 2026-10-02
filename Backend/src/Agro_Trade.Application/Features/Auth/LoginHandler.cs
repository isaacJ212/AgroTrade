using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Auth
{
    public record LoginCommand(LoginDto loginDto) : IRequest<Result<LoginResponse>>;
    public class LoginHandler : IRequestHandler<LoginCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly ITokenServices _token;
        private readonly IRepository<UsuarioRol> _rolRepo;
        private readonly IRepository<RefreshToken> _refreshTokens;
        private readonly IAppContext _appContext;

        public LoginHandler(IUnitofWork unitOfWork, IRepository<UsuarioRol> IRolRepo, ITokenServices token, IRepository<RefreshToken> RefreshTokens, IAppContext appContext)
        {
            _unitOfWork = unitOfWork;
            _token = token;
            _rolRepo = IRolRepo;    
            _appContext = appContext;
            _refreshTokens = RefreshTokens;
        }

        public async Task<Result<LoginResponse>> Handle(LoginCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.Users.GetByEmailAsync(request.loginDto.Email, cancellationToken);
            if (user == null)
            {
                return Result<LoginResponse>.Failure(401, "Contrase�a o Usuario incorrectos.");
            }
            if (!BCrypt.Net.BCrypt.Verify(request.loginDto.Password, user.PasswordHash))
            {
                return Result<LoginResponse>.Failure(401, "Contrase�a o Usuario incorrectos.");
            }
            var token = _token.GenerateRefreshToken();

            RefreshToken refreshToken = new()
            {
                Id = Guid.NewGuid(),
                UserId = user.IdUsuario,
                ExpiresAt = token.ExpiresAtUtc,
                CreatedAt = DateTime.UtcNow,
                Hash = token.HashedToken,
                CreatedByIp = _appContext.IpAdress,
            };
            var jwtToken = await _token.GenerateTokenAsync(user, refreshToken.Id);
            await _refreshTokens.AddAsync(refreshToken, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);
            
            
            var roles = await _rolRepo.FindAsync(r=> r.IdUsuario == user.IdUsuario,cancellationToken, "Rol");
            var stringList = roles
                    
            .Where(r => r.Rol != null)
            .Select(r => r.Rol.NombreRol)
            .ToList();
            

            var response = new LoginResponse
            {
                TokenResponse = new TokensResponse(jwtToken, token.RawToken, refreshToken.ExpiresAt),
                UserName = $"{user.Nombre} {user.PrimerApellido} {user.SegundoApellido}".Trim(),
                Roles = stringList

            };
            return Result<LoginResponse>.Success(200, response, "Inicio de sesi�n exitoso.", true);
        }
    }
}
