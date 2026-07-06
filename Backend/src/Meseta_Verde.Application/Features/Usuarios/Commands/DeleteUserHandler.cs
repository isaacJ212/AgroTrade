using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Usuarios.Commands
{
    public record DeleteUserCommand(int id) : IRequest<Result<Unit>>;
    public class DeleteUserHandler(IUnitofWork context) : IRequestHandler<DeleteUserCommand, Result<Unit>>
    {
        public async Task<Result<Unit>>Handle(DeleteUserCommand request, CancellationToken ct)
        {
            var exists = await context.Users.GetByIdAsync(request.id, ct);
            if (exists is null)
                return Result<Unit>.Failure(404, "Usuario no existe");

            await context.Users.RemoveUserAsync(request.id, ct);

            return Result<Unit>.Succes(204, Unit.Value, "Exito", true);
        }
    }
}
