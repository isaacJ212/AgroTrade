using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verda.Domain.Common.Purchases
{
    public class Cart
    {
        public int UserId { get; set; }
        public ICollection<CartItem> Items = new List<CartItem>();

    }
}
