using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Auth
{
    public class VerifyCodeHandler : IRequestHandler<VerifyCodeCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IVerificationCodeRepository _verificationCodeRepository;
        private readonly ITokenServices _tokenServices;
        private readonly IAppContext _appContext;
        private readonly IRepository<RefreshToken> _refreshTokens;

        public VerifyCodeHandler(IUnitofWork unitOfWork, IVerificationCodeRepository verificationCodeRepository, ITokenServices tokenServices, IAppContext appContext, IRepository<RefreshToken> refreshTokens)
        {
            _unitOfWork = unitOfWork;
            _verificationCodeRepository = verificationCodeRepository;
            _tokenServices = tokenServices;
            _appContext = appContext;
            _refreshTokens = refreshTokens;
        }

        public async Task<Result<LoginResponse>> Handle(VerifyCodeCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.Users.GetByIdAsync(request.dto.UserId, cancellationToken);
            if (user is null)
            {
                return Result<LoginResponse>.Failure(404, "Usuario no encontrado.");
            }

            var isValid = await _verificationCodeRepository.ValidateAndRemoveAsync(request.dto.UserId, request.dto.Code, cancellationToken);
            if (!isValid)
            {
                return Result<LoginResponse>.Failure(400, "El código es incorrecto o ha expirado.");
            }
            
            user.IdentidadVerificada = true;
            var tokenResult = _tokenServices.GenerateRefreshToken();

            RefreshToken refreshToken = new()
            {
                Id = Guid.NewGuid(),
                UserId = user.IdUsuario,
                ExpiresAt = tokenResult.ExpiresAtUtc,
                CreatedAt = DateTime.UtcNow,
                Hash = tokenResult.HashedToken,
                CreatedByIp = _appContext.IpAdress,
            };
            
            
            var token = await _tokenServices.GenerateTokenAsync(user, refreshToken.Id);
            await _refreshTokens.AddAsync(refreshToken, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

          
            var response = new LoginResponse
            {
                TokenResponse = new TokensResponse(token, tokenResult.RawToken, tokenResult.ExpiresAtUtc ),
                UserName = user.NombreCompleto,
                RequiereCompletarInformacion = false
            };

            return Result<LoginResponse>.Success(200, response, "Identidad verificada correctamente.", true);
        }
    }
}
