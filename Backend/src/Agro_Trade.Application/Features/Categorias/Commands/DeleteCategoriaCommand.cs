using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Categorias.Commands
{
    public record DeleteCategoriaCommand(int IdCategoria) : IRequest<Result<bool>>;

    public class DeleteCategoriaCommandHandler : IRequestHandler<DeleteCategoriaCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public DeleteCategoriaCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(DeleteCategoriaCommand request, CancellationToken cancellationToken)
        {
            if (request.IdCategoria <= 0)
            {
                return Result<bool>.Failure(400, "El ID de la categoría es inválido.");
            }

            var categoria = await _unitOfWork.Categorias.FirstOrDefaultAsync(
                c => c.IdCategoria == request.IdCategoria,
                cancellationToken,
                c => c.Productos);

            if (categoria is null)
            {
                return Result<bool>.Failure(404, "No se encontró la categoría.");
            }

            if (categoria.Productos.Any())
            {
                return Result<bool>.Failure(400, "No se puede eliminar la categoría porque tiene productos asociados.");
            }

            await _unitOfWork.Categorias.DeleteAsync(categoria, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Categoría eliminada correctamente.", true);
        }
    }
}