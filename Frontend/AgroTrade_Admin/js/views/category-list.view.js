

class CategoryListView {
  constructor() {
    this.searchTerm = '';
  }

  onEnter() {
    this.bindEvents();
    this.render();
  }

  bindEvents() {
    const searchInput = document.getElementById('categorySearchInput');
    if (searchInput) {
      searchInput.value = this.searchTerm;
      searchInput.oninput = (e) => {
        this.searchTerm = e.target.value.toLowerCase().trim();
        this.renderList();
      };
    }
  }

  render() {
    this.renderList();
  }

  renderList() {
    const container = document.getElementById('categoriesListContainer');
    if (!container) return;

    let list = adminStore.getCategories();

    if (this.searchTerm) {
      list = list.filter(c => 
        c.nombre.toLowerCase().includes(this.searchTerm) ||
        c.descripcion.toLowerCase().includes(this.searchTerm)
      );
    }

    if (list.length === 0) {
      container.innerHTML = `
        <div style="text-align:center; padding:30px 16px; color:var(--text-secondary);">
          No se encontraron categorías.
        </div>
      `;
      return;
    }

    container.innerHTML = list.map(cat => {
      
      let iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a5 5 0 0 1 5 5v1a5 5 0 0 1-10 0V7a5 5 0 0 1 5-5z"></path><path d="M4 14a8 8 0 0 0 16 0"></path></svg>`;
      if (cat.icono === 'apple' || cat.nombre.toLowerCase().includes('fruta')) {
        iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20.94c1.5 0 2.75 1.06 4 1.06 3 0 6-8 6-12.22A4.91 4.91 0 0 0 17 5c-2.22 0-4 1.44-5 2-1-.56-2.78-2-5-2a4.9 4.9 0 0 0-5 4.78C2 14 5 22 8 22c1.25 0 2.5-1.06 4-1.06Z"></path><path d="M10 2c1 .5 2 2 2 5"></path></svg>`;
      } else if (cat.icono === 'citrus' || cat.nombre.toLowerCase().includes('cítrico')) {
        iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M12 2a10 10 0 0 1 10 10"></path><line x1="12" y1="12" x2="19" y2="5"></line></svg>`;
      } else if (cat.icono === 'vegetable' || cat.nombre.toLowerCase().includes('verdura')) {
        iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m2 22 10-10"></path><path d="m9 9 5 5"></path><path d="M12 3a9 9 0 0 1 9 9c0 3-2 6-5 7"></path></svg>`;
      }

      return `
        <div class="category-item-card">
          <div class="category-left-group">
            <div class="category-icon-bubble">
              ${iconSvg}
            </div>
            <div class="category-info-wrap">
              <div class="category-name-text">${cat.nombre}</div>
              <span class="category-product-count-badge">${cat.conteoProductos} productos</span>
            </div>
          </div>

          <div class="category-actions-group">
            <button class="icon-action-btn" title="Editar" onclick="Toast.warning('Edición de categoría en desarrollo')">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
              </svg>
            </button>
            <button class="icon-action-btn btn-delete" title="Eliminar" onclick="categoryListView.deleteCategory(${cat.id})">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
              </svg>
            </button>
          </div>
        </div>
      `;
    }).join('');
  }

  deleteCategory(id) {
    if (confirm('¿Estás seguro de eliminar esta categoría?')) {
      adminStore.deleteCategory(id);
      Toast.success('Categoría eliminada');
      this.renderList();
    }
  }
}

const categoryListView = new CategoryListView();
