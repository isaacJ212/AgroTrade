using Meseta_Verda.Domain.Entities;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.Interface
{
  
    public interface IDeliveryRequestRepository
    {
        Task<ConcurrentQueue<SolicitudRepartidor>> GetUnseenRequestAsync(CancellationToken ct);
        Task<int> AddDeliveryRequestAsync(SolicitudRepartidor solicitudRepartidor, CancellationToken ct);
        Task<SolicitudRepartidor> ReviewRequestAsync(CancellationToken ct);
        Task<SolicitudRepartidor> GetByIdAsync(int id, CancellationToken ct);
        Task<bool> hasPendingRequest(int userId, CancellationToken ct);
        Task<SolicitudRepartidor> GetToUpdateAsync(int id,CancellationToken ct);
        void ConfirmarRevision();

    }
}
