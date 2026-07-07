using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.Repository
{
    public class UnitOfWork : IUnitOfWork
    {        private readonly IServiceProvider _serviceProvider;
        private readonly IRepository<Categoria> _categoriaRepository;
        private readonly IRepository<Producto> _productoRepository;
        private readonly MesetaVerdeDbContext _context;
        private IDbContextTransaction? _transaction;
        public UnitOfWork(MesetaVerdeDbContext context, IServiceProvider serviceProvider, IRepository<Categoria> categoriaRepository, IRepository<Producto> productoRepository)
        {
            _context = context;
            _serviceProvider = serviceProvider;
            _categoriaRepository = categoriaRepository;
            _productoRepository = productoRepository;
        }
        //PROPIEDADES DE NAVEGACION DE CONTEXTO
       /// comento esto por que me va a dar erro public IUserRepository Users => _serviceProvider.GetRequiredService<IUserRepository>();
        public IRepository<Categoria> Categorias => _categoriaRepository;
        public IRepository<Producto> Productos => _productoRepository;
        
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
