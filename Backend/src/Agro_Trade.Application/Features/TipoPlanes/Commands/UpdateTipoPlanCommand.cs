using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using System.Threading;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.TipoPlanes.Commands
{
    public class UpdateTipoPlanDto
    {
        public int IdTipoPlan { get; set; }
        public string NombrePlan { get; set; } = null!;
        public string Descripcion { get; set; } = null;
        public string Beneficios { get; set; } = null!;
        public decimal Precio { get; set; }
        public decimal Coste { get; set; }
        public bool Estado { get; set; }
    }

    public sealed record UpdateTipoPlanCommand(UpdateTipoPlanDto Dto) : IRequest<Result<int>>;

    public class UpdateTipoPlanHandler(IUnitofWork unitOfWork) : IRequestHandler<UpdateTipoPlanCommand, Result<int>>
    {
        public async Task<Result<int>> Handle(UpdateTipoPlanCommand request, CancellationToken ct)
        {
            var plan = await unitOfWork.TipoPlanes.GetByIdAsync(request.Dto.IdTipoPlan, ct);
            if (plan == null)
            {
                return Result<int>.Failure(404, "Plan no encontrado.");
            }

            plan.NombrePlan = request.Dto.NombrePlan;
            plan.Descripcion = request.Dto.Descripcion;
            plan.Beneficios = request.Dto.Beneficios;
            plan.Precio = request.Dto.Precio;
            plan.Coste = request.Dto.Coste;
            plan.IsActive = request.Dto.Estado;

            await unitOfWork.TipoPlanes.UpdateAsync(plan, ct);
            await unitOfWork.SaveChangesAsync(ct);

            return Result<int>.Success(200, plan.Id, "Plan actualizado con éxito.", true);
        }
    }
}
