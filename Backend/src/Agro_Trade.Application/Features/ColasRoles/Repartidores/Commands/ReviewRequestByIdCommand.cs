using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Helper;
using Agro_Trade.Domain.Events;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Commands
{
    public record ReviewRequestByIdCommand(int id, ReviewRequestDto dto) : IRequest<Result<SolicitudRepartidorDto>>;

    public class ReviewRequestByIdCommandHandler(IUnitofWork context, IRepository<UsuarioRol> roles, IRepository<Repartidor> repartidores, IRepository<CuentaBancaria> _cuentas) : IRequestHandler<ReviewRequestByIdCommand, Result<SolicitudRepartidorDto>>
    {
        public async Task<Result<SolicitudRepartidorDto>> Handle(ReviewRequestByIdCommand request, CancellationToken cancellationToken)
        {

            var dto = request.dto;
            var solicitud = await context.SolicitudRepartidor.GetToUpdateAsync(request.id, cancellationToken);
           
            

            if (solicitud == null) return Result<SolicitudRepartidorDto>.Failure(404, "Solicitud no encontrada");

            if (solicitud.Estado != "pendiente") return Result<SolicitudRepartidorDto>.Failure(400, "La solicitud ya ha sido revisada");

            
            CuentaBancaria? cuentaBancaria = null;
            int idCuenta = solicitud.DatosRepartidor.IdCuentaBancaria;

            if (idCuenta > 0)
            {
                cuentaBancaria =
                    await _cuentas.FirstOrDefaultAsync(c => c.IdCuenta == idCuenta, includes: b => b.Banco, cancellationToken:cancellationToken);
            }
            
            await context.BeginTransactionAsync(cancellationToken);


            try
            {
                if (dto.Estado == 1)
                {
                    solicitud.Estado = "Aprobada";
                    // COMO ES APROBADA, SE DEBE CREAR EL ROL DE REPARTIDOR PARA EL USUARIO ASI COMO SU PERFIL DE REPARTIDOR
                    await roles.AddAsync(new UsuarioRol
                    {
                        IdUsuario = solicitud.IdUsuario,
                        IdRol = 3 // ID del rol de repartidor
                    }, cancellationToken);

                    var repartidor = new Repartidor
                    {
                        IdUsuario = solicitud.IdUsuario,
                        // Inicializar otros campos del perfil de repartidor según sea necesario
                        PlacaVehiculo = solicitud.DatosRepartidor.PlacaVehiculo,
                        Vehiculo = solicitud.DatosRepartidor.TipoVehiculo,
                        IdCuentaBancaria = solicitud.DatosRepartidor.IdCuentaBancaria,
                        Municipio = solicitud.DatosRepartidor.ZonaOperaciones,
                        UrlFotoPerfil = solicitud.DatosRepartidor.UrlFotoPerfil,

                    };

                    await repartidores.AddAsync(repartidor, cancellationToken);

                }

                else if (dto.Estado == 2)
                {
                    solicitud.Estado = "Rechazada";

                }
                else
                {
                    return Result<SolicitudRepartidorDto>.Failure(400, "Estado de revisión no válido (1 = Aprobar, 2 = Rechazar)");
                }

                await context.SaveChangesAsync(cancellationToken);
                await context.CommitAsync(cancellationToken);

                context.SolicitudRepartidor.ConfirmarRevision();
                var solicitudDto = SolicitudHelper.ToDto(solicitud, cuentaBancaria);

                if (solicitudDto.Estado == "Rechazada") return Result<SolicitudRepartidorDto>.Success(200, solicitudDto, $"La Solicitud fue rechazada, Comentario del Moderador :{dto.Comentario}", false);

                return Result<SolicitudRepartidorDto>.Success(200, solicitudDto, "Solicitud revisada exitosamente", true);
            }
            catch (Exception ex)
            {
                await context.RollbackAsync(cancellationToken);
                return Result<SolicitudRepartidorDto>.Failure(500, $"Error al revisar la solicitud");
            }

        }



       
    }
}
