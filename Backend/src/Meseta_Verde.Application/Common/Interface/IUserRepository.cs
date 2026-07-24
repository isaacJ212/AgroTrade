

using Meseta_Verda.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.Interface
{
    public interface IUserRepository
    {
        Task<bool> UserExistsAsync(string email, CancellationToken ct);
        Task<Usuario> AddAsync(Usuario usuario, CancellationToken ct);
        Task<Usuario?> GetByIdAsync(int id, CancellationToken ct);
        Task<Usuario?> GetByEmailAsync(string email, CancellationToken ct);
        Task<Usuario?> GetByOAuthProviderAsync(string provider, string providerId, CancellationToken ct);
        Task<Usuario?> GetToUpdateAsync(int id, CancellationToken ct);
        Task<bool> AnyAsync(Expression<Func<Usuario,bool>> predicate, CancellationToken ct);
        Task RemoveUserAsync(int id,CancellationToken ct);

        Task<IEnumerable<string>> GetRolesByUserIdAsync(int userId, CancellationToken ct);


    }
}
