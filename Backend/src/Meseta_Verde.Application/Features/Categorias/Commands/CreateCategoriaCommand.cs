using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;

namespace Meseta_Verde.Application.Features.Categorias.Commands
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
            var categoria = new Categoria { Nombre = request.Nombre };
            await _unitOfWork.Categorias.AddAsync(categoria, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Succes(201, categoria.IdCategoria, "Categoría creada correctamente.", true);
        }
    }
}