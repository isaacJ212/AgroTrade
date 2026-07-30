using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Application.Features.Categorias.Commands
{
    public record CreateCategoriaCommand(string Nombre) : IRequest<Result<int>>;

    public class CreateCategoriaCommandHandler : IRequestHandler<CreateCategoriaCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;

        public CreateCategoriaCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<int>> Handle(CreateCategoriaCommand request, CancellationToken cancellationToken)
        {
            var nombreExistente = await _unitOfWork.Categorias.AnyAsync(
                c => c.Nombre.ToLower() == request.Nombre.ToLower(), cancellationToken);
            if (nombreExistente)
            {
                return Result<int>.Failure(409, "Ya existe una categoría con ese nombre.");
            }

            var categoria = new Categoria { Nombre = request.Nombre };
            await _unitOfWork.Categorias.AddAsync(categoria, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Success(201, categoria.IdCategoria, "Categoría creada correctamente.", true);
        }
    }
}