using BCrypt.Net;
using EFCore.NamingConventions.Internal;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.Repository
{
    // NO HACER CONFUSION DE SOLICITUDES NORMALES DE DELIVERY, ESTA ENTIDAD Y REPOSITORIO ESTAN DIRIGIDAS  LA GESTION DE LA COLA DE SOLICITUD DE ELEVACION DE ROLES
    public class DeliveryRequestRespository : IDeliveryRequestRepository
    {
        private readonly SemaphoreSlim _lock  = new SemaphoreSlim(1,1);
        private bool isLoaded = false;
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ConcurrentQueue<SolicitudRepartidor> _colaDeSolicitudes;

        public DeliveryRequestRespository(IServiceScopeFactory factory)
        {
            _scopeFactory = factory;
            _colaDeSolicitudes = new ConcurrentQueue<SolicitudRepartidor>();

        }

        private async Task EnsureEnqueued(CancellationToken ct)
        {
            //Validamos Si Esta Cargada
            if (isLoaded) return;
            await _lock.WaitAsync();
            try
            {
                //validamos de nuevo
                if (isLoaded) return;
                using var scope = _scopeFactory.CreateScope();
                var context = scope.ServiceProvider.GetRequiredService<MesetaVerdeDbContext>();

                var lista = await context.SolicitudRepartidor.AsNoTracking().Include(x => x.Usuario).Where(x => x.Estado == "pendiente").ToListAsync(ct);
                _colaDeSolicitudes.Clear();
                Enqueue(lista);
                //Hcaemos La Carga de scope
                isLoaded = true;
            }
            finally
            {
                _lock.Release();
            }
        }
        public void Enqueue(List<SolicitudRepartidor> lista)
        {
            foreach (var i in lista)
            {
                _colaDeSolicitudes.Enqueue(i);
            }
        }

        public async Task<ConcurrentQueue<SolicitudRepartidor>> GetUnseenRequestAsync(CancellationToken ct)
        {
            //LIMPIAMOS PARA EVITAR DUPLICADOS EN LA COLA DE SOLICITUDES
            await EnsureEnqueued(ct);
            return _colaDeSolicitudes;

        }

        public async Task<SolicitudRepartidor> GetByIdAsync(int id, CancellationToken ct)
        {
            using var scope = _scopeFactory.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<MesetaVerdeDbContext>();
            var solicitud = await context.SolicitudRepartidor.AsNoTracking().Include(d=>d.Usuario).FirstOrDefaultAsync(x => x.IdSolicitud == id, ct);
            return solicitud;
        }

        public async Task<SolicitudRepartidor>ReviewRequestAsync(CancellationToken ct)
        {
            await EnsureEnqueued(ct);
            if(_colaDeSolicitudes.TryPeek (out var solicitud))
            {

                using var scope = _scopeFactory.CreateScope();
                var context = scope.ServiceProvider.GetRequiredService<MesetaVerdeDbContext>();
                
                var solicitudPorRevisar = await context.SolicitudRepartidor.Include(d=>d.Usuario).AsNoTracking().FirstOrDefaultAsync(x => x.IdSolicitud == solicitud.IdSolicitud, ct);
                if(solicitudPorRevisar != null)
                {
                    return solicitudPorRevisar;
                }


            }
            return null;
        }

        public async Task<int> AddDeliveryRequestAsync(SolicitudRepartidor solicitud, CancellationToken ct)
        {
            using var scope = _scopeFactory.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<MesetaVerdeDbContext>();
            var newEntity=await context.SolicitudRepartidor.AddAsync(solicitud, ct);
            await context.SaveChangesAsync();
            _colaDeSolicitudes.Enqueue(solicitud);
            return newEntity.Entity.IdSolicitud;

        }

        public async Task<SolicitudRepartidor> GetToUpdateAsync(int id, CancellationToken ct)
        {
            using var scope = _scopeFactory.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<MesetaVerdeDbContext>();
            var solicitud = await context.SolicitudRepartidor.Include(d => d.Usuario).FirstOrDefaultAsync(x => x.IdSolicitud == id, ct);
            return solicitud;
        }

        public async Task<bool> hasPendingRequest(int userId, CancellationToken ct)
        {
            
            using var scope = _scopeFactory.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<MesetaVerdeDbContext>();
            var solicitud = await context.SolicitudRepartidor.AsNoTracking().AnyAsync(x => x.IdUsuario == userId && x.Estado == "pendiente", ct);
            return solicitud;
        }

        public void ConfirmarRevision()
        {
            _colaDeSolicitudes.TryDequeue(out _);
        }
    }
}
