using Agro_Trade.Application.Common;
using MediatR;
using System.Threading;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Usuarios.Commands
{
    public class ToggleUserStatusCommand : IRequest<Result<bool>>
    {
        public int UserId { get; set; }

        public ToggleUserStatusCommand(int userId)
        {
            UserId = userId;
        }
    }

    public class ToggleUserStatusCommandHandler : IRequestHandler<ToggleUserStatusCommand, Result<bool>>
    {
        private readonly IUnitofWork _context;

        public ToggleUserStatusCommandHandler(IUnitofWork context)
        {
            _context = context;
        }

        public async Task<Result<bool>> Handle(ToggleUserStatusCommand request, CancellationToken cancellationToken)
        {
            var user = await _context.Usuarios.GetByIdAsync(request.UserId, cancellationToken);

            if (user == null)
            {
                return Result<bool>.Failure(404, "Usuario no encontrado.");
            }

            user.EstadoCuenta = user.EstadoCuenta == "Activo" ? "Suspendido" : "Activo";
            await _context.Usuarios.UpdateAsync(user, cancellationToken);
            await _context.CommitAsync(cancellationToken);

            return Result<bool>.Success(200, true, $"Estado del usuario actualizado a {user.EstadoCuenta}", true);
        }
    }
}
