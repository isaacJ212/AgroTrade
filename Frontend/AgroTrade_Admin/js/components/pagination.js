function createPagination(totalCount, currentPage, pageSize, onPageChange) {
  const totalPages = Math.ceil(totalCount / pageSize);
  if (totalPages <= 1) return '';

  let html = '<div class="pagination-container">';
  
  // Botón Anterior
  html += `<button class="pagination-btn" ${currentPage === 1 ? 'disabled' : ''} onclick="${onPageChange}(${currentPage - 1})">&larr; Prev</button>`;

  // Lógica para mostrar páginas (ej. 1, 2, 3, ..., 10)
  const maxPagesToShow = 5;
  let startPage = Math.max(1, currentPage - Math.floor(maxPagesToShow / 2));
  let endPage = startPage + maxPagesToShow - 1;

  if (endPage > totalPages) {
    endPage = totalPages;
    startPage = Math.max(1, endPage - maxPagesToShow + 1);
  }

  if (startPage > 1) {
    html += `<button class="pagination-btn" onclick="${onPageChange}(1)">1</button>`;
    if (startPage > 2) {
      html += `<span class="pagination-dots">...</span>`;
    }
  }

  for (let i = startPage; i <= endPage; i++) {
    html += `<button class="pagination-btn ${i === currentPage ? 'active' : ''}" onclick="${onPageChange}(${i})">${i}</button>`;
  }

  if (endPage < totalPages) {
    if (endPage < totalPages - 1) {
      html += `<span class="pagination-dots">...</span>`;
    }
    html += `<button class="pagination-btn" onclick="${onPageChange}(${totalPages})">${totalPages}</button>`;
  }

  // Botón Siguiente
  html += `<button class="pagination-btn" ${currentPage === totalPages ? 'disabled' : ''} onclick="${onPageChange}(${currentPage + 1})">Next &rarr;</button>`;

  html += '</div>';
  return html;
}
