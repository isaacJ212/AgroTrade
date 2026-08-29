using Agro_Trade.Domain.Common.Purchases;
using Agro_Trade.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.Interface
{
    public interface ICartRepository
    {
         Task<Cart> GetCart(int userId);
         Task SaveCart(Cart cart);
         Task ClearCart(int userId);

        Task<IEnumerable<Producto>> GetProductsInTheCart(int userId);
    }
}
