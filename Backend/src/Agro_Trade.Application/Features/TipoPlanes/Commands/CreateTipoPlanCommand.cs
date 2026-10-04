using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using System.Threading;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.TipoPlanes.Commands
{
    public class CreateTipoPlanDto
    {
        public string NombrePlan { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
        public string Beneficios { get; set; } = null!;
        public decimal Precio { get; set; }
        public decimal Coste { get; set; }
        public bool IsActive { get; set; } = true;
    }

    public sealed record CreateTipoPlanCommand(CreateTipoPlanDto Dto) : IRequest<Result<int>>;

    public class CreateTipoPlanHandler(IUnitofWork unitOfWork) : IRequestHandler<CreateTipoPlanCommand, Result<int>>
    {
        public async Task<Result<int>> Handle(CreateTipoPlanCommand request, CancellationToken ct)
        {
            var nuevoPlan = new TipoPlan
            {
                NombrePlan = request.Dto.NombrePlan,
                Descripcion = request.Dto.Descripcion,
                Beneficios = request.Dto.Beneficios,
                Precio = request.Dto.Precio,
                Coste = request.Dto.Coste,
                IsActive = request.Dto.IsActive
            };

            await unitOfWork.TipoPlanes.AddAsync(nuevoPlan, ct);
            await unitOfWork.SaveChangesAsync(ct);

            return Result<int>.Success(201, nuevoPlan.Id, "Plan de suscripción creado con éxito.", true);
        }
    }
}
