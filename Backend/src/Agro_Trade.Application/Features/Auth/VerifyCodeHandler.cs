using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Auth
{
    public class VerifyCodeHandler : IRequestHandler<VerifyCodeCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IVerificationCodeRepository _verificationCodeRepository;
        private readonly ITokenServices _tokenServices;
        private readonly IAppContext _appContext;

        public VerifyCodeHandler(IUnitofWork unitOfWork, IVerificationCodeRepository verificationCodeRepository, ITokenServices tokenServices, IAppContext appContext )
        {
            _unitOfWork = unitOfWork;
            _verificationCodeRepository = verificationCodeRepository;
            _tokenServices = tokenServices;
            _appContext = appContext;
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
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            var token = await _tokenServices.GenerateTokenAsync(user);
            var response = new LoginResponse
            {
                TokenResponse = new TokenResponse(token, ),
                UserName = user.NombreCompleto,
                RequiereCompletarInformacion = false
            };

            return Result<LoginResponse>.Success(200, response, "Identidad verificada correctamente.", true);
        }
    }
}
