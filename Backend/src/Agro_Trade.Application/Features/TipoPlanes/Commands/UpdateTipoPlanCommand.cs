using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using System.Threading;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.TipoPlanes.Commands
{
    public class UpdateTipoPlanDto
    {
        public int IdPlan { get; set; }
        public string NombrePlan { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
        public string Beneficios { get; set; } = null!;
        public decimal Precio { get; set; }
        public decimal Coste { get; set; }
        public bool IsActive { get; set; }
    }

    public sealed record UpdateTipoPlanCommand(UpdateTipoPlanDto Dto) : IRequest<Result<bool>>;

    public class UpdateTipoPlanHandler(IUnitofWork unitOfWork) : IRequestHandler<UpdateTipoPlanCommand, Result<bool>>
    {
        public async Task<Result<bool>> Handle(UpdateTipoPlanCommand request, CancellationToken ct)
        {
            var plan = await unitOfWork.TipoPlanes.FirstOrDefaultAsync(p => p.Id == request.Dto.IdPlan, ct);
            if (plan == null)
            {
                return Result<bool>.Failure(404, $"Plan con ID {request.Dto.IdPlan} no encontrado.");
            }

            plan.NombrePlan = request.Dto.NombrePlan;
            plan.Descripcion = request.Dto.Descripcion;
            plan.Beneficios = request.Dto.Beneficios;
            plan.Precio = request.Dto.Precio;
            plan.Coste = request.Dto.Coste;
            plan.IsActive = request.Dto.IsActive;

            await unitOfWork.TipoPlanes.UpdateAsync(plan, ct);
            await unitOfWork.SaveChangesAsync(ct);

            return Result<bool>.Success(200, true, "Plan actualizado con éxito.", true);
        }
    }
}
