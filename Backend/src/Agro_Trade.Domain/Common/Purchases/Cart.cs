using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Domain.Common.Purchases
{
    public class Cart
    {
        public int UserId { get; set; }
        public ICollection<CartItem> Items { get; set; } = new List<CartItem>();
    }
}
