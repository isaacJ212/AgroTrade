using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Categorias.Commands
{
    public record UpdateCategoriaCommand(int IdCategoria, string Nombre) : IRequest<Result<bool>>;

    public class UpdateCategoriaCommandHandler : IRequestHandler<UpdateCategoriaCommand, Result<bool>>
    {
        private readonly IUnitofWork         _unitOfWork;

        public UpdateCategoriaCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(UpdateCategoriaCommand request, CancellationToken cancellationToken)
        {
            if (request.IdCategoria <= 0)
            {
                return Result<bool>.Failure(400, "El ID de la categoría es inválido.");
            }

            var categoria = await _unitOfWork.Categorias.GetByIdAsync(request.IdCategoria, cancellationToken);
            if (categoria is null)
            {
                return Result<bool>.Failure(404, "No se encontró la categoría.");
            }

            var nombreExistente = await _unitOfWork.Categorias.AnyAsync(
                c => c.IdCategoria != request.IdCategoria && c.Nombre.ToLower() == request.Nombre.ToLower(), cancellationToken);
            if (nombreExistente)
            {
                return Result<bool>.Failure(409, "Ya existe una categoría con ese nombre.");
            }

            categoria.Nombre = request.Nombre;
            await _unitOfWork.Categorias.UpdateAsync(categoria, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Categoría actualizada correctamente.", true);
        }
    }
}