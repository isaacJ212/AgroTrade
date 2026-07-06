using Meseta_Verde.Application.Interfaces;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.Persistence.UnitofWork
{
    public class UnitOfWork: IUnitofWork
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly MesetaVerdeDbContext _context;
        private IDbContextTransaction? _transaction;
        public UnitOfWork(MesetaVerdeDbContext context, IServiceProvider serviceProvider)
        {
            _context = context;
            _serviceProvider = serviceProvider;
        }
        //PROPIEDADES DE NAVEGACION DE CONTEXTO
        public IUserRepository Users => _serviceProvider.GetRequiredService<IUserRepository>();

        //CONFIGURACIONES DE PERSISTENCIA
        public async Task BeginTransactionAsync(CancellationToken ct)
        {
            _transaction =  await _context.Database.BeginTransactionAsync(ct);
        }
        public async Task<int>SaveChangesAsync(CancellationToken ct)
        {
            return await _context.SaveChangesAsync(ct);
        }
        public async Task CommitAsync(CancellationToken ct)
        {
            try
            {
                   await _context.SaveChangesAsync(ct);
                if (_transaction != null)
                {
                    await _transaction.CommitAsync(ct);
                }



            }
            catch
            {
                await _transaction.RollbackAsync(ct);
                throw;
            }
            finally
            {
                if (_transaction != null)
                {
                    await _transaction.DisposeAsync();
                }
            }
        }
        public async Task RollbackAsync(CancellationToken ct)
        {
            await _transaction.RollbackAsync(ct);
        }
    }
}
