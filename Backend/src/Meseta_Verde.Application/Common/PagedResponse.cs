using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common
{
    public class PagedResponse<T>
    {
        public List<T> Items { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages => (int)Math.Ceiling((double)this.TotalRegisters / PageSize);
        public int TotalRegisters { get; set; }
        public bool HasPreviousPage => PageIndex > 1;
        public bool HasNextPage => PageIndex < TotalPages;

        public static PagedResponse<T> ToPagedResponse(List<T> items, int pageIndex, int PageSize, int totalRegisters)
        {
            return new PagedResponse<T>
            {
                Items = items,
                PageIndex = pageIndex,
                PageSize = PageSize,
                TotalRegisters = totalRegisters
            };
        }
    }
}
