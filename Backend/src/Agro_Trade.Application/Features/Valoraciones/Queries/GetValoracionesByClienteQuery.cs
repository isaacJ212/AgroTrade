using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ValoracionesDtos;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Valoraciones.Queries
{
    public record GetValoracionesByClienteQuery(int IdUsuarioCliente) : IRequest<Result<List<ValoracionDto>>>;

    public class GetValoracionesByClienteQueryHandler : IRequestHandler<GetValoracionesByClienteQuery, Result<List<ValoracionDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetValoracionesByClienteQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<ValoracionDto>>> Handle(GetValoracionesByClienteQuery request, CancellationToken cancellationToken)
        {
            var valoraciones = await _unitOfWork.Valoraciones
                .FindAsync(v => v.IdUsuarioCliente == request.IdUsuarioCliente, cancellationToken,
                    v => v.UsuarioCliente, v => v.Proveedor);

            var dtos = valoraciones
                .OrderByDescending(v => v.FechaValoracion)
                .Select(v => new ValoracionDto
                {
                    IdValoracion = v.IdValoracion,
                    IdPedido = v.IdPedido,
                    IdUsuarioCliente = v.IdUsuarioCliente,
                    NombreCliente = v.UsuarioCliente.NombreCompleto,
                    IdProveedor = v.IdProveedor,
                    NombreProveedor = v.Proveedor.NombreProveedor,
                    TipoValoracion = v.TipoValoracion,
                    Puntuacion = v.Puntuacion,
                    Comentario = v.Comentario,
                    FechaValoracion = v.FechaValoracion
                }).ToList();

            return Result<List<ValoracionDto>>.Success(200, dtos, "Valoraciones obtenidas correctamente.", true);
        }
    }
}
