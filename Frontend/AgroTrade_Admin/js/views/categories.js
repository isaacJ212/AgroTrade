document.addEventListener('DOMContentLoaded', () => {
  authService.guardRoute();

  if (document.getElementById('categoriesListContainer')) {
    initCategoryList();
  }

  if (document.getElementById('btnSubmitCreateCategory')) {
    initCategoryForm();
  }
});

let currentCategorySearch = '';

async function initCategoryList() {
  const searchInput = document.getElementById('categorySearchInput');
  if (searchInput) {
    searchInput.oninput = (e) => {
      currentCategorySearch = e.target.value.toLowerCase().trim();
      renderCategoryList();
    };
  }

  await renderCategoryList();
}

async function renderCategoryList() {
  const container = document.getElementById('categoriesListContainer');
  if (!container) return;

  let list = await adminStore.getCategories();

  if (currentCategorySearch) {
    list = list.filter(c => 
      c.nombre.toLowerCase().includes(currentCategorySearch) ||
      (c.descripcion && c.descripcion.toLowerCase().includes(currentCategorySearch))
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
    
    const iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a5 5 0 0 1 5 5v1a5 5 0 0 1-10 0V7a5 5 0 0 1 5-5z"></path><path d="M4 14a8 8 0 0 0 16 0"></path></svg>`;

    return `
      <div class="category-item-card">
        <div class="category-left-group">
          <div class="category-icon-bubble">
            ${iconSvg}
          </div>
          <div class="category-info-wrap">
            <div class="category-name-text">${cat.nombre}</div>
            <span class="category-product-count-badge">${cat.conteoProductos || 0} productos</span>
          </div>
        </div>

        <div class="category-actions-group">
          <a href="nueva-categoria.html?id=${cat.id}" class="icon-action-btn" title="Editar" style="text-decoration:none;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
            </svg>
          </a>
          <button class="icon-action-btn btn-delete" title="Eliminar" onclick="deleteCategoryAction(${cat.id})">
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

window.deleteCategoryAction = async function(id) {
  if (confirm('¿Estás seguro de eliminar esta categoría?')) {
    await adminStore.deleteCategory(id);
    Toast.success('Categoría eliminada');
    await renderCategoryList();
  }
}

async function initCategoryForm() {
  const params = new URLSearchParams(window.location.search);
  const editId = params.get('id');
  const submitBtn = document.getElementById('btnSubmitCreateCategory');
  const nameInput = document.getElementById('categoryNameInput');
  const descInput = document.getElementById('categoryDescInput');
  const descGroup = document.getElementById('categoryDescGroup');
  const errorMsg = document.getElementById('categoryDescError');
  const titleEl = document.querySelector('.subpage-title');

  let isEditing = false;
  let targetCategory = null;

  if (editId) {
    targetCategory = await adminStore.getCategoryById(editId);
    if (targetCategory) {
      isEditing = true;
      if (titleEl) titleEl.textContent = 'Editar Categoría';
      if (nameInput) nameInput.value = targetCategory.nombre;
      if (descInput) descInput.value = targetCategory.descripcion || '';
      if (submitBtn) submitBtn.querySelector('span').textContent = 'Guardar cambios';
    }
  }

  if (submitBtn) {
    submitBtn.onclick = async () => {
      const name = nameInput ? nameInput.value.trim() : '';
      const desc = descInput ? descInput.value.trim() : '';

      if (!name) {
        Toast.warning('Por favor ingresa el nombre de la categoría.');
        nameInput?.focus();
        return;
      }

      submitBtn.disabled = true;

      if (isEditing && targetCategory) {
        await adminStore.updateCategory(targetCategory.id, {
          nombre: name,
          descripcion: desc
        });
        Toast.success(`Categoría "${name}" actualizada exitosamente.`);
      } else {
        await adminStore.addCategory({
          nombre: name,
          descripcion: desc,
          icono: 'apple'
        });
        Toast.success(`Categoría "${name}" creada exitosamente.`);
      }

      setTimeout(() => {
        window.location.href = 'categorias.html';
      }, 400);
    };
  }
}
