using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Usuarios.Commands
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

            return Result<Unit>.Success(204, Unit.Value, "Exito", true);
        }
    }
}
