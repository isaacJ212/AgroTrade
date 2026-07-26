using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verda.Domain.Events;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.DatosSolicitudRoles;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.ColasRoles.Repartidores.Queries
{
    public record GetUnSeenRequestQuery(int pageIndex, int PageSize) : IRequest<Result<PagedResponse<SolicitudRepartidorDto>>>;
    
    
    public class GetUnSeenHandler(IUnitofWork context) : IRequestHandler<GetUnSeenRequestQuery, Result<PagedResponse<SolicitudRepartidorDto>>>
    {
        public async Task<Result<PagedResponse<SolicitudRepartidorDto>>> Handle(GetUnSeenRequestQuery request, CancellationToken cancellationToken)
        {
            if(request.pageIndex <= 0 || request.PageSize <= 0)
            {
                return Result<PagedResponse<SolicitudRepartidorDto>>.Failure(400, "Los parámetros de paginación son inválidos");
            }

            var unseenRequests = await context.SolicitudRepartidor.GetUnseenRequestAsync(cancellationToken);
            if(unseenRequests == null || !unseenRequests.Any())
            {
                return Result<PagedResponse<SolicitudRepartidorDto>>.Failure(404, "No se encontraron solicitudes pendientes");
            }
            var unseenRequestsDto = unseenRequests.Select(s => new SolicitudRepartidorDto
            {
                IdSolicitud = s.IdSolicitud,
                IdUsuario = s.IdUsuario,
                NombreUsuario = s.Usuario.NombreCompleto,
                DatosRepartidor = new DatosRepartidorDto
                {
                    TipoVehiculo = s.DatosRepartidor.TipoVehiculo,
                    PlacaVehiculo = s.DatosRepartidor.PlacaVehiculo,
                    UrlFotoCedula = s.DatosRepartidor.UrlFotoCedula,
                    UrlFotoPerfil = s.DatosRepartidor.UrlFotoPerfil,
                    UrlLicencia = s.DatosRepartidor.UrlLicencia,
                    UrlRecordPolicial = s.DatosRepartidor.UrlRecordPolicial,
                    BancoNombre = s.DatosRepartidor.BancoNombre,
                    NumeroCedula = s.DatosRepartidor.NumeroCedula,
                    NumeroCuenta = s.DatosRepartidor.NumeroCuenta,
                    MarcaVehiculo = s.DatosRepartidor.MarcaVehiculo,
                    ZonaOperaciones = s.DatosRepartidor.ZonaOperaciones,
                    Departamento = s.DatosRepartidor.Departamento?? ""
                },
                Estado = s.Estado,
                FechaSolicitud = s.FechaSolicitud
            }).ToList();

            var totalRegisters = unseenRequestsDto.Count;
            var listWithPagination = unseenRequestsDto.Skip((request.pageIndex - 1) * request.PageSize).Take(request.PageSize).ToList();
            var pagedResponse = PagedResponse<SolicitudRepartidorDto>.ToPagedResponse(listWithPagination, request.pageIndex, request.PageSize, totalRegisters);
            return Result<PagedResponse<SolicitudRepartidorDto>>.Success(200, pagedResponse, "Exito", true);
        }
    
    }
}
