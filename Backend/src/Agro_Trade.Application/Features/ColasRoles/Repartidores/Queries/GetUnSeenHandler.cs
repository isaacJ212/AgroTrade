using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Domain.Events;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Helper;

namespace Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries
{
    public record GetUnSeenRequestQuery(int pageIndex, int PageSize) : IRequest<Result<PagedResponse<SolicitudRepartidorDto>>>;
    
    public class GetUnSeenHandler(IUnitofWork context, IRepository<CuentaBancaria> _cuentas) : IRequestHandler<GetUnSeenRequestQuery, Result<PagedResponse<SolicitudRepartidorDto>>>
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

            // 1. Guardamos la cantidad total de registros antes de paginar
            var totalRegisters = unseenRequests.Count;

            // 2. PASO CLAVE: Paginamos primero la colección cruda en memoria
            var solicitudesPaginadas = unseenRequests
                .Skip((request.pageIndex - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToList();

            // 3. Extraemos los IDs de cuenta ÚNICAMENTE de los elementos que se van a mostrar en esta página
            var idCuentas = solicitudesPaginadas
                .Select(r => r.DatosRepartidor.IdCuentaBancaria)
                .Where(id => id > 0)
                .Distinct()
                .ToList();
            
            var diccionario = new Dictionary<int, CuentaBancaria>();
            
            if (idCuentas.Any())
            {
                // La consulta SQL ahora es pequeñísima porque solo busca los IDs de la página actual
                var cuentasLista = await _cuentas.FindAsync(
                    c => idCuentas.Contains(c.IdCuenta), 
                    includes: b => b.Banco,
                    cancellationToken: cancellationToken);

                diccionario = cuentasLista.ToDictionary(c => c.IdCuenta);
            }
            
            // 4. Mapeamos al DTO final solo los elementos de la página actual
            var listWithPagination = solicitudesPaginadas
                .Select(solicitud => 
                {
                    diccionario.TryGetValue(solicitud.DatosRepartidor.IdCuentaBancaria, out var cuenta);
                    return SolicitudHelper.ToDto(solicitud, cuenta);
                })
                .ToList();
            
            // 5. Metemos la lista ya paginada y el total global al objeto de paginación
            var pagedResponse = PagedResponse<SolicitudRepartidorDto>.ToPagedResponse(listWithPagination, request.pageIndex, request.PageSize, totalRegisters);
            return Result<PagedResponse<SolicitudRepartidorDto>>.Success(200, pagedResponse, "Exito", true);
        }
    }
}
