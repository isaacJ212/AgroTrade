using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.AuthServices;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Auth
{
    public record LoginCommand(LoginDto loginDto) : IRequest<Result<LoginResponse>>;
    public class LoginHandler : IRequestHandler<LoginCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly ITokenServices _token;

        public LoginHandler(IUnitofWork unitOfWork, ITokenServices token)
        {
            _unitOfWork = unitOfWork;
            _token = token;
        }

        public async Task<Result<LoginResponse>> Handle(LoginCommand request, CancellationToken cancellationToken)
        {
            var user = await _unitOfWork.Users.GetByEmailAsync(request.loginDto.Email, cancellationToken);
            if (user == null)
            {
                return Result<LoginResponse>.Failure(401, "Contraseña o Usuario incorrectos.");
            }
            if (!BCrypt.Net.BCrypt.Verify(request.loginDto.Password, user.PasswordHash))
            {
                return Result<LoginResponse>.Failure(401, "Contraseña o Usuario incorrectos.");
            }
            var token = await _token.GenerateTokenAsync(user);
            var response = new LoginResponse
            {
                Token = token,
                UserName = user.NombreCompleto

            };
            return Result<LoginResponse>.Succes(200, response, "Inicio de sesión exitoso.", true);
        }
    }
}
