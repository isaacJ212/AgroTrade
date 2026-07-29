using Meseta_Verda.Domain.Common.Purchases;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.Extensions.Caching.Memory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.Repository
{
    public class CartRepository : ICartRepository
    {
        private readonly IMemoryCache _cache;
        private readonly TimeSpan _cacheExpiration = TimeSpan.FromDays(1);
        private readonly MesetaVerdeDbContext _context;

        public CartRepository(IMemoryCache cache, MesetaVerdeDbContext context)
        {
            _cache = cache;
            _context = context;
        }

        public Task<Cart> GetCart(int userId)
        {
            string cacheKey = $"cart_of_{userId}";
            if (!_cache.TryGetValue(cacheKey, out Cart cart))
            {
               cart = new Cart { UserId = userId, Items = new List<CartItem>() };

            }
            return Task.FromResult(cart);
        }

        public Task SaveCart(Cart cart)
        {
            string cacheKey = $"cart_of_{cart.UserId}";
            var entryOptions = new MemoryCacheEntryOptions().SetSlidingExpiration(_cacheExpiration);
            _cache.Set(cacheKey, cart, entryOptions);
            return Task.CompletedTask;
        }

        public Task ClearCart(int userId)
        {
            string cacheKey = $"cart_of_{userId}";
            _cache.Remove(cacheKey);
            return Task.CompletedTask;
        }

        public async Task<IEnumerable<Producto>> GetProductsInTheCart(int userId)
        {
           var cart = await GetCart(userId);
           var productIds =  cart.Items.Select(item => item.ProductId).ToList();
            var products = await _context.Productos.AsNoTracking().Include(p=> p.Proveedor).Where(p => productIds.Contains(p.IdProducto)).ToListAsync();
            return products;
        }
    }
}
