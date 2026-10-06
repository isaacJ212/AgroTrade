using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Domain.Events;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Helper;
using Microsoft.AspNetCore.Http;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Commands
{
    public record CreateDeliveryReqCommand(int IdUsuario, CreateDatosRepartidorDto DatosRepartidor) : IRequest<Result<SolicitudRepartidorDto>>;


    public class CreateDeliveryReqHandler(IStorageService _storageService,IUnitofWork context, IRepository<SolicitudRepartidor> repo, IRepository<CuentaBancaria> _bancaria) : IRequestHandler<CreateDeliveryReqCommand, Result<SolicitudRepartidorDto>>
    {
        public async Task<Result<SolicitudRepartidorDto>> Handle(CreateDeliveryReqCommand request, CancellationToken cancellationToken)
        {
            var usuario = await context.Users.GetByIdAsync(request.IdUsuario, cancellationToken);
            if (usuario == null)
            {
                return Result<SolicitudRepartidorDto>.Failure(404, "Usuario no encontrado");
            }
            var cuentaBancaria = await _bancaria.FirstOrDefaultAsync(c=> c.IdCuenta == request.DatosRepartidor.IdCuentaBancaria 
                                                                         && c.IdUsuario == request.IdUsuario, cancellationToken);
            if(cuentaBancaria is null) return Result<SolicitudRepartidorDto>.Failure(400, "Cuenta Bancaria no Existe");
            
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

            var fileUrls = await _bulkUploadAsync(dto, cancellationToken);
            var datosRepartidor = MapToDatosRepartidorDto(dto, fileUrls);
            var solicitud = new SolicitudRepartidor
            {
                IdUsuario = request.IdUsuario,
                DatosRepartidor = datosRepartidor
            };
             await repo.AddAsync(entity: solicitud, cancellationToken: cancellationToken);
            await context.SaveChangesAsync(cancellationToken);
            //Traemos la entidad con carga de navegacion

            var newRequest = await context.SolicitudRepartidor.GetByIdAsync(solicitud.IdSolicitud, cancellationToken);
            CuentaBancaria? cuenta = null;
            int idCuenta = newRequest.DatosRepartidor.IdCuentaBancaria;
            cuenta = await _bancaria.FirstOrDefaultAsync(p => p.IdBanco == idCuenta, includes: p => p.Banco,
                cancellationToken: cancellationToken);
            
            
            var resultDto = SolicitudHelper.ToDto(newRequest, cuenta);

            return Result<SolicitudRepartidorDto>.Success(201, resultDto, "Exito Al Crear Solicitud", true);
        }

        private DatosRepartidorDto MapToDatosRepartidorDto(
            CreateDatosRepartidorDto dto,
            IReadOnlyDictionary<string, string> fileUrls)
        {
            return new DatosRepartidorDto
            {
                NumeroCedula = dto.NumeroCedula,
                PlacaVehiculo = dto.PlacaVehiculo,
                TipoVehiculo = dto.TipoVehiculo,
                UrlFotoPerfil = fileUrls.GetValueOrDefault(nameof(dto.FotoPerfil), string.Empty),
                UrlFotoCedula = fileUrls.GetValueOrDefault(nameof(dto.FotoCedula), string.Empty),
                UrlRecordPolicial = fileUrls.GetValueOrDefault(nameof(dto.RecordPolicial), string.Empty),
                UrlLicencia = fileUrls.GetValueOrDefault(nameof(dto.FotoLicencia), string.Empty),
                MarcaVehiculo = dto.MarcaVehiculo,
                ZonaOperaciones = dto.ZonaOperaciones,
                IdCuentaBancaria = dto.IdCuentaBancaria,
                Departamento = dto.Departamento
            };
        }

        private async Task<string> _uploadFotoToSupabase(IFormFile foto, CancellationToken ct)
        {
            if (foto is null)
                return null;

            //obtenemos el nombre del archivo y el arreglo de bytes para subirlos
            var nombre = foto.FileName;
            using var memoryStream = new MemoryStream();
            await foto.CopyToAsync(memoryStream, ct);
            memoryStream.Position = 0;

            //validamos el formato de archivo
            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".webp" };
            var extension = Path.GetExtension(nombre).ToLowerInvariant();
            if (!allowedExtensions.Contains(extension))
                return null;

            //subimos a supabase   Backend   git:(refactor/ModeloBd)  

            string bucketName = "imagenes_meseta_verde";
            string uniqueName = $"{Guid.NewGuid()}{extension}";

            string fotoUrl = await _storageService.UploadFileAsync(memoryStream, bucketName, uniqueName, ct);

            //retornamos

            return fotoUrl;
        }

        private async Task<Dictionary<string, string>> _bulkUploadAsync(CreateDatosRepartidorDto dto,
            CancellationToken ct)
        {
            var uploadTask = new Dictionary<string, Task<string>>();
            Dictionary<string, string> results = new();

            if (dto.FotoCedula is not null)
                results.Add(nameof(dto.FotoCedula), await _uploadFotoToSupabase(dto.FotoCedula, ct));

            if (dto.FotoPerfil is not null)
                results.Add(nameof(dto.FotoPerfil), await _uploadFotoToSupabase(dto.FotoPerfil, ct));

            if (dto.RecordPolicial is not null)
                results.Add(nameof(dto.RecordPolicial), await _uploadFotoToSupabase(dto.RecordPolicial, ct));

            if (dto.FotoLicencia is not null)
                results.Add(nameof(dto.FotoLicencia), await _uploadFotoToSupabase(dto.FotoLicencia, ct));

            return results;
        }


        

        
    }
}
