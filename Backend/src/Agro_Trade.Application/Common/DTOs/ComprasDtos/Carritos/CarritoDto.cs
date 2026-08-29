using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.ComprasDtos.Carritos
{
    public class CarritoDto
    {
        public int UserId { get; set; }
        public List<ItemCarritoDto> Items { get; set; } = new List<ItemCarritoDto>();
    }

    public class ItemCarritoDto
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string SupplierName { get; set; }
        public int Quantity { get; set; }
    }
}
