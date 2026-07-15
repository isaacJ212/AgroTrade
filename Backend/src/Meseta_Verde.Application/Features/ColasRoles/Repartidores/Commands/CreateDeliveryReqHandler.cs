using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verda.Domain.Events;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.DatosSolicitudRoles;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.ColasRoles.Repartidores.Commands
{
    public record CreateDeliveryReqCommand(int IdUsuario, CreateDatosRepartidorDto DatosRepartidor) : IRequest<Result<SolicitudRepartidorDto>>;


    public class CreateDeliveryReqHandler(IUnitofWork context, IRepository<SolicitudRepartidor> repo) : IRequestHandler<CreateDeliveryReqCommand, Result<SolicitudRepartidorDto>>
    {
        public async Task<Result<SolicitudRepartidorDto>> Handle(CreateDeliveryReqCommand request, CancellationToken cancellationToken)
        {
            var usuario = await context.Users.GetByIdAsync(request.IdUsuario, cancellationToken);
            if (usuario == null)
            {
                return Result<SolicitudRepartidorDto>.Failure(404, "Usuario no encontrado");
            }
            var rolesExistentes = await context.Users.GetRolesByUserIdAsync(usuario.IdUsuario, cancellationToken);
            if (rolesExistentes.Any(p=> p.Contains("repartidor")))
            {
                return Result<SolicitudRepartidorDto>.Failure(400, "Este Usuario Ya Es Repartidor");
            }

            var existeSolicitud = await context.SolicitudRepartidor.hasPendingRequest(request.IdUsuario, cancellationToken);
            if (existeSolicitud)
            {
                return Result<SolicitudRepartidorDto>.Failure(400, "Ya existe una solicitud pendiente para este usuario");
            }
            var dto = request.DatosRepartidor;

            var datosRepartidor = MapToDatosRepartidorDto(dto);
            var solicitud = new SolicitudRepartidor
            {
                IdUsuario = request.IdUsuario,
                DatosRepartidor = datosRepartidor
            };
             await repo.AddAsync(entity: solicitud, cancellationToken: cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
            //Traemos la entidad con carga de navegacion

            var newRequest = await context.SolicitudRepartidor.GetByIdAsync(solicitud.IdSolicitud, cancellationToken);
            var resultDto = ToDto(newRequest);

            return Result<SolicitudRepartidorDto>.Success(201, resultDto, "Exito Al Crear Solicitud", true);
        }

        public DatosRepartidorDto MapToDatosRepartidorDto(CreateDatosRepartidorDto dto)
        {
            return new DatosRepartidorDto
            {
                NumeroCedula = dto.NumeroCedula,
                PlacaVehiculo = dto.PlacaVehiculo,
                TipoVehiculo = dto.TipoVehiculo,
                UrlFotoPerfil = dto.UrlFotoPerfil,
                UrlFotoCedula = dto.UrlFotoCedula,
                UrlRecordPolicial = dto.UrlRecordPolicial,
                UrlLicencia = dto.UrlLicencia,
                MarcaVehiculo = dto.MarcaVehiculo,
                ZonaOperaciones = dto.ZonaOperaciones,
                BancoNombre = dto.BancoNombre,
                NumeroCuenta = dto.NumeroCuenta
            };
        }

        public SolicitudRepartidorDto ToDto(SolicitudRepartidor solicitud)
        {
            return new SolicitudRepartidorDto
            {
                IdSolicitud = solicitud.IdSolicitud,
                IdUsuario = solicitud.IdUsuario,
                NombreUsuario = solicitud.Usuario?.NombreCompleto ?? string.Empty,
                DatosRepartidor = solicitud.DatosRepartidor,
                Estado = solicitud.Estado,
                FechaSolicitud = solicitud.FechaSolicitud
            };
        }
    }
}
