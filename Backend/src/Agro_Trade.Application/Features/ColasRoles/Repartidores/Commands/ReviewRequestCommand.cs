using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Helper;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Commands
{

    public record ReviewRequestCommand(ReviewRequestDto dto) : IRequest<Result<SolicitudRepartidorDto>>;

    public class ReviewRequestHandler(
        IUnitofWork context,
        IRepository<UsuarioRol> roles,
        IRepository<SolicitudRepartidor> contextoSoli,
        IRepository<Repartidor> repartidores,
        IRepository<CuentaBancaria> _banc) : IRequestHandler<ReviewRequestCommand, Result<SolicitudRepartidorDto>>
    {
        public async Task<Result<SolicitudRepartidorDto>> Handle(ReviewRequestCommand request,
            CancellationToken cancellationToken)
        {

            var dto = request.dto;
            var solicitud = await context.SolicitudRepartidor.ReviewRequestAsync(cancellationToken);

            if (solicitud == null) return Result<SolicitudRepartidorDto>.Failure(404, "Solicitud no encontrada");

            if (solicitud.Estado != "pendiente")
                return Result<SolicitudRepartidorDto>.Failure(400, "La solicitud ya ha sido revisada");

            await contextoSoli.UpdateAsync(solicitud, cancellationToken);
            await context.BeginTransactionAsync(cancellationToken);


            try
            {
                if (dto.Estado == 1)
                {
                    solicitud.Estado = "Aprobada";
                   

                    var repartidor = new Repartidor
                    {
                        IdUsuario = solicitud.IdUsuario,
                        // Inicializar otros campos del perfil de repartidor según sea necesario
                        PlacaVehiculo = solicitud.DatosRepartidor.PlacaVehiculo,
                        Vehiculo = solicitud.DatosRepartidor.TipoVehiculo,
                        IdCuentaBancaria = solicitud.DatosRepartidor.IdCuentaBancaria,
                        Municipio = solicitud.DatosRepartidor.ZonaOperaciones,
                        UrlFotoPerfil = solicitud.DatosRepartidor.UrlFotoPerfil,
                        Departamento = solicitud.DatosRepartidor.Departamento,
                        IsActive = true

                    };

                    await repartidores.AddAsync(repartidor, cancellationToken);

                }

                else if (dto.Estado == 2)
                {
                    solicitud.Estado = "Rechazada";

                }
                else
                {
                    return Result<SolicitudRepartidorDto>.Failure(400,
                        "Estado de revisión no válido (1 = Aprobar, 2 = Rechazar)");
                }

                await context.SaveChangesAsync(cancellationToken);
                await context.CommitAsync(cancellationToken);

                context.SolicitudRepartidor.ConfirmarRevision();
                var Cuenta = await _banc.FirstOrDefaultAsync(c=>c.IdCuenta == solicitud.DatosRepartidor.IdCuentaBancaria, includes:b=>b.Banco, cancellationToken:cancellationToken);
                var solicitudDto = SolicitudHelper.ToDto(solicitud, Cuenta);

                if (solicitudDto.Estado == "Rechazada")
                    return Result<SolicitudRepartidorDto>.Success(200, solicitudDto,
                        $"La Solicitud fue rechazada, Comentario del Moderador :{dto.Comentario}", false);

                return Result<SolicitudRepartidorDto>.Success(200, solicitudDto, "Solicitud revisada exitosamente",
                    true);
            }
            catch (Exception ex)
            {
                await context.RollbackAsync(cancellationToken);
                return Result<SolicitudRepartidorDto>.Failure(500, $"Error al revisar la solicitud");
            }

        }



    
}
}


