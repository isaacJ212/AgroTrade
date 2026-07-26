using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.AuthServices;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Auth
{
    public class VerifyCodeHandler : IRequestHandler<VerifyCodeCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IVerificationCodeRepository _verificationCodeRepository;
        private readonly ITokenServices _tokenServices;

        public VerifyCodeHandler(IUnitofWork unitOfWork, IVerificationCodeRepository verificationCodeRepository, ITokenServices tokenServices)
        {
            _unitOfWork = unitOfWork;
            _verificationCodeRepository = verificationCodeRepository;
            _tokenServices = tokenServices;
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
                Token = token,
                UserName = user.NombreCompleto
            };

            return Result<LoginResponse>.Succes(200, response, "Identidad verificada correctamente.", true);
        }
    }
}
