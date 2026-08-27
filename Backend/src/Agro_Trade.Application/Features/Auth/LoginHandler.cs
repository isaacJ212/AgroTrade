using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Auth
{
    public record LoginCommand(LoginDto loginDto) : IRequest<Result<LoginResponse>>;
    public class LoginHandler : IRequestHandler<LoginCommand, Result<LoginResponse>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly ITokenServices _token;
        private readonly IRepository<UsuarioRol> _rolRepo;

        public LoginHandler(IUnitofWork unitOfWork, IRepository<UsuarioRol> IRolRepo, ITokenServices token)
        {
            _unitOfWork = unitOfWork;
            _token = token;
            _rolRepo = IRolRepo;            
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
            var token = await _token.GenerateTokenAsync(user);
            var roles = await _rolRepo.FindAsync(r=> r.IdUsuario == user.IdUsuario,cancellationToken, "Rol");
            var stringList = roles
    .Where(r => r.Rol != null)
    .Select(r => r.Rol.NombreRol)
    .ToList();
            

            var response = new LoginResponse
            {
                Token = token,
                UserName = user.NombreCompleto,
                Roles = stringList

            };
            return Result<LoginResponse>.Success(200, response, "Inicio de sesi�n exitoso.", true);
        }
    }
}
