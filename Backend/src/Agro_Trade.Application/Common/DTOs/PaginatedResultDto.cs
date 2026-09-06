using System.Collections.Generic;

namespace Agro_Trade.Application.Common.DTOs
{
    public class PaginatedResultDto<T>
    {
        public int TotalItems { get; set; }
        public int TotalPages { get; set; }
        public int CurrentPage { get; set; }
        public List<T> Items { get; set; } = new List<T>();
    }
}
