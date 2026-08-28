

class UserListView {
  constructor() {
    this.currentTab = 'todas';
    this.searchTerm = '';
  }

  onEnter() {
    this.bindEvents();
    this.render();
  }

  bindEvents() {
    const searchInput = document.getElementById('userSearchInput');
    if (searchInput) {
      searchInput.value = this.searchTerm;
      searchInput.oninput = (e) => {
        this.searchTerm = e.target.value.toLowerCase().trim();
        this.renderList();
      };
    }

    const filterTabs = document.querySelectorAll('#userFilterTabs .filter-tab-pill');
    filterTabs.forEach(tab => {
      tab.onclick = () => {
        filterTabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        this.currentTab = tab.getAttribute('data-filter');
        this.renderList();
      };
    });
  }

  render() {
    this.renderList();
  }

  renderList() {
    const container = document.getElementById('usersCardsContainer');
    if (!container) return;

    let users = adminStore.getUsers();

    
    if (this.currentTab === 'productores') {
      users = users.filter(u => u.tipoRol === 'productor');
    } else if (this.currentTab === 'compradores') {
      users = users.filter(u => u.tipoRol === 'comprador');
    } else if (this.currentTab === 'repartidores') {
      users = users.filter(u => u.tipoRol === 'repartidor');
    }

    
    if (this.searchTerm) {
      users = users.filter(u => 
        u.nombreCompleto.toLowerCase().includes(this.searchTerm) ||
        u.email.toLowerCase().includes(this.searchTerm) ||
        u.rolLabel.toLowerCase().includes(this.searchTerm)
      );
    }

    if (users.length === 0) {
      container.innerHTML = `
        <div style="text-align:center; padding:30px 16px; color:var(--text-secondary);">
          No se encontraron usuarios con los filtros aplicados.
        </div>
      `;
      return;
    }

    container.innerHTML = users.map(user => {
      
      let roleBadgeClass = 'badge-productor';
      if (user.tipoRol === 'comprador') roleBadgeClass = 'badge-comprador';
      if (user.tipoRol === 'repartidor') roleBadgeClass = 'badge-repartidor';

      const verifiedBadge = user.isVerificado 
        ? `<span class="badge-pill badge-verificado">✓ Verificado</span>`
        : '';

      const statusDot = user.estadoCuenta === 'Activo' 
        ? `<span class="status-dot-green"></span>`
        : `<span class="status-dot-amber"></span>`;

      
      const avatarHtml = user.avatarUrl
        ? `<img src="${user.avatarUrl}" alt="${user.nombreCompleto}" class="applicant-avatar-round" />`
        : `<div class="user-initials-avatar">${user.nombreCompleto.slice(0, 2).toUpperCase()}</div>`;

      return `
        <div class="user-list-card">
          <div class="user-list-card-header">
            ${avatarHtml}
            <div>
              <div class="applicant-name-title">${user.nombreCompleto}</div>
              <div class="user-badges-row">
                <span class="badge-pill ${roleBadgeClass}">${user.rolLabel}</span>
                ${verifiedBadge}
              </div>
              <div class="user-status-text" style="margin-top: 4px;">
                ${statusDot}
                <span>Estado: ${user.estadoCuenta}</span>
              </div>
            </div>
          </div>

          <button class="btn-outline" onclick="router.navigateTo('usuario-detalle', { userId: ${user.id} })">
            <span>Ver detalle</span>
          </button>
        </div>
      `;
    }).join('');
  }
}

const userListView = new UserListView();
