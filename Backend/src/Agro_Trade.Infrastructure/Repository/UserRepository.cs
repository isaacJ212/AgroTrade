using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Infrastructure.Repository
{
    public class UserRepository : IUserRepository
    {
        private readonly AgroTradeDbContext _context;
        public UserRepository(AgroTradeDbContext context)
        {
            _context = context;
        }

        public async Task<bool> UserExistsAsync(string email, CancellationToken ct)
        {
            return await _context.Usuarios.AsNoTracking().AnyAsync(u =>  u.Email == email  , ct);
        }
        public async Task<Usuario> AddAsync(Usuario usuario, CancellationToken ct)
        {
           var response = await _context.Usuarios.AddAsync(usuario, ct);

            return response.Entity;
        }
        public async Task<bool>AnyAsync(Expression<Func<Usuario, bool>> predicate, CancellationToken ct)
        {
            return await _context.Usuarios.AnyAsync(predicate, ct);
        }

        public async Task<Usuario?> GetByIdAsync(int id, CancellationToken ct)
        {
            return await _context.Usuarios.AsNoTracking().FirstOrDefaultAsync(u => u.IdUsuario == id, ct);
        }
        public async Task<Usuario?> GetByEmailAsync(string email, CancellationToken ct)
        {
            return await _context.Usuarios.AsNoTracking().FirstOrDefaultAsync(u => u.Email == email, ct);
        }

        public async Task<Usuario?> GetByOAuthProviderAsync(string provider, string providerId, CancellationToken ct)
        {
            return await _context.Usuarios.AsNoTracking().FirstOrDefaultAsync(u => u.OAuthProvider == provider && u.OAuthProviderId == providerId, ct);
        }

        public async Task<Usuario?> GetToUpdateAsync(int id, CancellationToken ct)
        {
            return await _context.Usuarios.FirstOrDefaultAsync(u => u.IdUsuario == id, ct);
        }

        public async Task RemoveUserAsync(int id,CancellationToken ct)
        {
            var user = await _context.Usuarios.FindAsync(id, ct);
            if(user != null)
            {
                _context.Usuarios.Remove(user);
                await _context.SaveChangesAsync(ct);
            }
        }

        public async Task<IEnumerable<string>> GetRolesByUserIdAsync(int userId, CancellationToken ct)
        {
            return await _context.UsuariosRoles
                .Where(ur => ur.IdUsuario == userId)
                .Select(ur => ur.Rol.NombreRol)
                .ToListAsync(ct);
        }
    }
}
