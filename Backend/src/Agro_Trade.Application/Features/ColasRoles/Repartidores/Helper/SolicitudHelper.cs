using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Domain.Events;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Helper;

public class SolicitudHelper
{
    public static SolicitudRepartidorDto ToDto(SolicitudRepartidor solicitud, CuentaBancaria cuentaBancaria)
    {
        return new SolicitudRepartidorDto
        {
            IdSolicitud = solicitud.IdSolicitud,
            IdUsuario = solicitud.IdUsuario,
            NombreUsuario = $"{solicitud.Usuario.Nombre} {solicitud.Usuario.PrimerApellido}",
            DatosRepartidor = toDatosDto(solicitud.DatosRepartidor, cuentaBancaria),
            Estado = solicitud.Estado,
            FechaSolicitud = solicitud.FechaSolicitud,
            Departamento = solicitud.DatosRepartidor?.Departamento ?? string.Empty,
        };
    }

    public static UnseenRequestDto toDatosDto(DatosRepartidorDto dto, CuentaBancaria bac)
    {
        return new UnseenRequestDto
        {
            MarcaVehiculo = dto.MarcaVehiculo,
            BancoNombre = bac?.Banco?.NombreBanco ?? "anon",
            NumeroCuenta = bac?.NumeroCuenta ?? "anon",
            NumeroCedula = dto.NumeroCedula,
            PlacaVehiculo = dto.PlacaVehiculo,
            TipoVehiculo = dto.TipoVehiculo,
            Departamento = dto.Departamento,
            UrlFotoCedula = dto.UrlFotoCedula,
            UrlFotoPerfil = dto.UrlFotoPerfil,
            UrlRecordPolicial = dto.UrlRecordPolicial,
            UrlLicencia = dto.UrlLicencia
        };
    }
}