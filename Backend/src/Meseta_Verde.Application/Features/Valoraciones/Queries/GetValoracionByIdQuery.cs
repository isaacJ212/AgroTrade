using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ValoracionesDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Valoraciones.Queries
{
    public record GetValoracionByIdQuery(int IdValoracion) : IRequest<Result<ValoracionDto>>;

    public class GetValoracionByIdQueryHandler : IRequestHandler<GetValoracionByIdQuery, Result<ValoracionDto>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetValoracionByIdQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<ValoracionDto>> Handle(GetValoracionByIdQuery request, CancellationToken cancellationToken)
        {
            var valoracion = await _unitOfWork.Valoraciones
                .FirstOrDefaultAsync(v => v.IdValoracion == request.IdValoracion, cancellationToken,
                    v => v.UsuarioCliente, v => v.Proveedor);

            if (valoracion == null)
            {
                return Result<ValoracionDto>.Failure(404, "La valoración especificada no existe.");
            }

            var dto = new ValoracionDto
            {
                IdValoracion = valoracion.IdValoracion,
                IdPedido = valoracion.IdPedido,
                IdUsuarioCliente = valoracion.IdUsuarioCliente,
                NombreCliente = valoracion.UsuarioCliente.NombreCompleto,
                IdProveedor = valoracion.IdProveedor,
                NombreProveedor = valoracion.Proveedor.NombreProveedor,
                TipoValoracion = valoracion.TipoValoracion,
                Puntuacion = valoracion.Puntuacion,
                Comentario = valoracion.Comentario,
                FechaValoracion = valoracion.FechaValoracion
            };

            return Result<ValoracionDto>.Success(200, dto, "Valoración obtenida correctamente.", true);
        }
    }
}
