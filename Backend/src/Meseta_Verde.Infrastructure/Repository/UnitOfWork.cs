using Meseta_Verde.Application.Common.Interface;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Infrastructure.Persistence;

namespace Meseta_Verde.Infrastructure.Repository
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly MesetaVerdeDbContext _context;

        public UnitOfWork(MesetaVerdeDbContext context)
        {
            _context = context;
            Categorias = new Repository<Categoria>(_context);
        }

        public IRepository<Categoria> Categorias { get; }

        public Task<int> SaveChangesAsync(CancellationToken cancellationToken)
            => _context.SaveChangesAsync(cancellationToken);
    }
}
