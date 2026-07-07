using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;

namespace Meseta_Verde.Application.Common.Interface
{
    public interface IUnitOfWork
    {
        // UNIDAD DE PERSISTENCIA - Transacciones
        Task BeginTransactionAsync(CancellationToken cancellationToken);
        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
        Task CommitAsync(CancellationToken cancellationToken);
        Task RollbackAsync(CancellationToken cancellationToken);

        // NAVEGACION PARA REPOSITORIOS
        IRepository<Categoria> Categorias { get; }
    }
}
