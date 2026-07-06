using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;

namespace Meseta_Verde.Application.Common.Interface
{
    public interface IUnitOfWork
    {
        IRepository<Categoria> Categorias { get; }
        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}
