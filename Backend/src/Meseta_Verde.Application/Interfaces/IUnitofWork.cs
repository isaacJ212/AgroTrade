using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Interfaces
{
    public interface IUnitofWork
    {
        // UNIDAD DE PERSISTENCIA
        Task BeginTransactionAsync(CancellationToken ct);
        Task<int> SaveChangesAsync(CancellationToken ct);
        Task CommitAsync(CancellationToken ct);
        Task RollbackAsync(CancellationToken ct);
        // NAVEGACION PARA REPOSITORIOS 
        public IUserRepository Users { get; }
    }
}
