
class AgroTradeAdminApp {
  constructor() {
    this.activeTab = 'resumen';
    this.currentFilter = 'all';
  }

  init() {

    authManager.guardRoute();
    deliveryManager.init();

    this.bindNavigationEvents();
    this.bindSidebarMobileEvents();
    this.bindProfileEvents();
    this.bindSearchEvent();
    this.renderDashboard();
    this.updateBadges();
  }

  bindNavigationEvents() {
    const navItems = document.querySelectorAll('.sidebar-link');
    navItems.forEach(item => {
      item.addEventListener('click', (e) => {
        const tab = item.getAttribute('data-tab');
        if (tab) {
          this.switchTab(tab);
          this.closeMobileSidebar();
        }
      });
    });

    
    const viewAllPendingLink = document.getElementById('viewAllPendingBtn');
    if (viewAllPendingLink) {
      viewAllPendingLink.addEventListener('click', (e) => {
        e.preventDefault();
        this.switchTab('solicitudes-repartidores');
      });
    }
  }

  bindSidebarMobileEvents() {
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const overlay = document.getElementById('sidebarOverlay');
    const sidebar = document.getElementById('adminSidebar');

    if (mobileMenuBtn && sidebar && overlay) {
      mobileMenuBtn.addEventListener('click', () => {
        sidebar.classList.add('open');
        overlay.classList.add('active');
      });

      overlay.addEventListener('click', () => {
        this.closeMobileSidebar();
      });
    }
  }

  closeMobileSidebar() {
    const overlay = document.getElementById('sidebarOverlay');
    const sidebar = document.getElementById('adminSidebar');
    if (sidebar) sidebar.classList.remove('open');
    if (overlay) overlay.classList.remove('active');
  }

  bindProfileEvents() {
    const logoutBtn = document.getElementById('logoutBtn');
    const sidebarLogoutBtn = document.getElementById('sidebarLogoutBtn');
    
    if (logoutBtn) {
      logoutBtn.addEventListener('click', () => authManager.logout());
    }
    if (sidebarLogoutBtn) {
      sidebarLogoutBtn.addEventListener('click', () => authManager.logout());
    }

    const notificationBtn = document.getElementById('topbarNotifBtn');
    if (notificationBtn) {
      notificationBtn.addEventListener('click', () => {
        deliveryManager.showToast('Tienes 3 notificaciones pendientes de revisión.', 'warning');
      });
    }
  }

  bindSearchEvent() {
    const searchInput = document.getElementById('globalSearchInput');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const term = e.target.value.toLowerCase().trim();
        if (this.activeTab === 'solicitudes-repartidores') {
          this.renderDeliveryRequestsTable(term);
        } else if (this.activeTab === 'usuarios') {
          this.renderUsersView(term);
        }
      });
    }
  }

  switchTab(tabName) {
    this.activeTab = tabName;

 
    document.querySelectorAll('.sidebar-link').forEach(btn => {
      btn.classList.toggle('active', btn.getAttribute('data-tab') === tabName);
    });


    document.querySelectorAll('.tab-view').forEach(view => {
      view.classList.add('hidden');
    });

 
    const activeView = document.getElementById(`view-${tabName}`);
    if (activeView) {
      activeView.classList.remove('hidden');
    }

    if (tabName === 'resumen') {
      this.renderDashboard();
    } else if (tabName === 'solicitudes-repartidores') {
      this.renderDeliveryRequestsTable();
    } else if (tabName === 'usuarios') {
      this.renderUsersView();
    } else if (tabName === 'catalogo') {
      this.renderCatalogView();
    } else if (tabName === 'perfil') {
      this.renderProfileView();
    }

    this.updateBadges();
  }

  updateBadges() {
    const pending = store.getPendingRequests();
    const badge = document.getElementById('sidebarRepartidoresBadge');
    const pendingCountBadge = document.getElementById('pendingCountBadge');

    if (badge) badge.textContent = pending.length;
    if (pendingCountBadge) pendingCountBadge.textContent = `${pending.length} activas`;
  }

  renderDashboard() {
    this.renderStats();
    this.renderPendingReviews();
    this.renderRecentActivity();
    this.updateBadges();
  }

  renderStats() {
    const stats = store.getStats();
    const pendingRequests = store.getPendingRequests();

    const usersEl = document.getElementById('statUsers');
    const producersEl = document.getElementById('statProducers');
    const pendingEl = document.getElementById('statPending');
    const categoriesEl = document.getElementById('statCategories');

    if (usersEl) usersEl.textContent = stats.registeredUsers;
    if (producersEl) producersEl.textContent = stats.producers;
    if (pendingEl) pendingEl.textContent = pendingRequests.length;
    if (categoriesEl) categoriesEl.textContent = stats.categories;
  }

  renderPendingReviews() {
    const container = document.getElementById('pendingReviewsList');
    if (!container) return;

    const pending = store.getPendingRequests();

    if (pending.length === 0) {
      container.innerHTML = `
        <div style="text-align: center; padding: 40px 20px; background: #ffffff; border-radius: var(--radius-lg); border: 1px dashed var(--border-light); color: var(--text-secondary);">
          <svg width="42" height="42" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2" style="margin-bottom: 10px;"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
          <div style="font-weight: 800; color: var(--text-main); font-size: 1.05rem;">¡Todas las solicitudes revisadas!</div>
          <div style="font-size: 0.85rem; margin-top: 4px;">No hay verificaciones pendientes de repartidores o productores en este momento.</div>
        </div>
      `;
      return;
    }

    container.innerHTML = pending.map(item => {
      const isProductor = item.tipoRol === 'productor';
      const roleIcon = isProductor
        ? `<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><circle cx="6" cy="18" r="3"></circle><circle cx="18" cy="18" r="3"></circle><path d="M3 18h12v-6H8l-2 3H3"></path><path d="M14 9V4h-4"></path></svg>`
        : `<svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>`;

      return `
        <div class="review-card">
          <div class="review-card-top">
            <div class="review-card-user">
              <img src="${item.avatarUrl || item.datosRepartidor?.urlFotoPerfil}" alt="${item.nombreUsuario}" class="user-avatar-md" />
              <div class="review-user-info">
                <div class="review-user-name">${item.nombreUsuario}</div>
                <div class="review-user-role">
                  ${roleIcon}
                  <span>${isProductor ? 'Productor' : 'Repartidor'} • ${item.datosRepartidor?.departamento || 'Nicaragua'}</span>
                </div>
              </div>
            </div>
            <span class="badge badge-amber">Pendiente</span>
          </div>
          
          <div class="review-description-box">
            ${item.descripcionCorta || 'Solicitud de verificación y alta de documentos en AgroTrade.'}
          </div>

          <div class="review-card-footer">
            <div class="review-date-tag">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
              <span>Vehículo: ${item.datosRepartidor?.tipoVehiculo || 'No especificado'}</span>
            </div>

            <button class="btn-review-primary" onclick="deliveryManager.openReviewModal(${item.idSolicitud})">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path>
                <rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect>
                <path d="m9 14 2 2 4-4"></path>
              </svg>
              <span>Revisar</span>
            </button>
          </div>
        </div>
      `;
    }).join('');
  }

  renderRecentActivity() {
    const listContainer = document.getElementById('recentActivityList');
    if (!listContainer) return;

    const activities = store.getActivities();

    listContainer.innerHTML = activities.map(act => {
      let icon = '';
      if (act.iconClass === 'bg-blue') {
        icon = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><line x1="20" y1="8" x2="20" y2="14"></line><line x1="23" y1="11" x2="17" y2="11"></line></svg>`;
      } else if (act.iconClass === 'bg-gray') {
        icon = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>`;
      } else if (act.iconClass === 'bg-green') {
        icon = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`;
      } else {
        icon = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;
      }

      return `
        <li class="activity-item">
          <div class="activity-icon-wrap ${act.iconClass}">
            ${icon}
          </div>
          <div class="activity-details">
            <div class="activity-title">${act.title}</div>
            <div class="activity-time">${act.time}</div>
          </div>
        </li>
      `;
    }).join('');
  }

  filterRequests(filterType) {
    this.currentFilter = filterType;
    document.querySelectorAll('.filter-pill').forEach(pill => {
      pill.classList.remove('active');
    });
    event.target.classList.add('active');
    this.renderDeliveryRequestsTable();
  }

  renderDeliveryRequestsTable(searchTerm = '') {
    const tbody = document.getElementById('deliveryRequestsTableBody');
    if (!tbody) return;

    let requests = store.getRequests().filter(r => r.tipoRol === 'repartidor');


    if (this.currentFilter === 'pending') {
      requests = requests.filter(r => r.estado === 0);
    } else if (this.currentFilter === 'approved') {
      requests = requests.filter(r => r.estado === 1);
    } else if (this.currentFilter === 'rejected') {
      requests = requests.filter(r => r.estado === 2);
    }


    if (searchTerm) {
      requests = requests.filter(r => 
        r.nombreUsuario.toLowerCase().includes(searchTerm) ||
        (r.datosRepartidor?.numeroCedula || '').toLowerCase().includes(searchTerm) ||
        (r.datosRepartidor?.placaVehiculo || '').toLowerCase().includes(searchTerm)
      );
    }

    if (requests.length === 0) {
      tbody.innerHTML = `
        <tr>
          <td colspan="6" style="text-align: center; padding: 36px; color: var(--text-secondary);">
            No se encontraron solicitudes que coincidan con los filtros aplicados.
          </td>
        </tr>
      `;
      return;
    }

    tbody.innerHTML = requests.map(req => {
      const statusBadge = req.estado === 1 
        ? `<span class="badge badge-green">Aprobado</span>`
        : req.estado === 2 
          ? `<span class="badge badge-red">Rechazado</span>`
          : `<span class="badge badge-amber">Pendiente</span>`;

      return `
        <tr>
          <td>
            <div style="display: flex; align-items: center; gap: 12px;">
              <img src="${req.avatarUrl || req.datosRepartidor?.urlFotoPerfil}" alt="${req.nombreUsuario}" style="width: 38px; height: 38px; border-radius: var(--radius-full); object-fit: cover;" />
              <div>
                <div style="font-weight: 700; color: var(--text-main);">${req.nombreUsuario}</div>
                <div style="font-size: 0.76rem; color: var(--text-secondary);">ID: #${req.idSolicitud}</div>
              </div>
            </div>
          </td>
          <td>
            <span style="font-family: monospace; font-weight: 600; font-size: 0.85rem;">${req.datosRepartidor?.numeroCedula || 'N/A'}</span>
          </td>
          <td>
            <div style="font-weight: 600; font-size: 0.86rem;">${req.datosRepartidor?.tipoVehiculo || 'N/A'}</div>
            <div style="font-size: 0.76rem; color: var(--text-secondary);">${req.datosRepartidor?.placaVehiculo || 'Sin placa'}</div>
          </td>
          <td>${req.datosRepartidor?.zonaOperaciones || req.datosRepartidor?.departamento || 'Nicaragua'}</td>
          <td>${statusBadge}</td>
          <td style="text-align: right;">
            <button class="btn btn-approve" style="padding: 7px 16px; font-size: 0.82rem;" onclick="deliveryManager.openReviewModal(${req.idSolicitud})">
              <span>${req.estado === 0 ? 'Revisar' : 'Ver Detalles'}</span>
            </button>
          </td>
        </tr>
      `;
    }).join('');
  }

  renderUsersView(searchTerm = '') {
    const listContainer = document.getElementById('allUsersList');
    if (!listContainer) return;

    let allRequests = store.getRequests();

    if (searchTerm) {
      allRequests = allRequests.filter(r => 
        r.nombreUsuario.toLowerCase().includes(searchTerm) ||
        (r.datosRepartidor?.departamento || '').toLowerCase().includes(searchTerm)
      );
    }

    listContainer.innerHTML = allRequests.map(req => {
      const statusBadge = req.estado === 1 
        ? `<span class="badge badge-green">Aprobado</span>`
        : req.estado === 2 
          ? `<span class="badge badge-red">Rechazado</span>`
          : `<span class="badge badge-amber">Pendiente</span>`;

      return `
        <div class="review-card">
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <div class="review-card-user">
              <img src="${req.avatarUrl || req.datosRepartidor?.urlFotoPerfil}" alt="${req.nombreUsuario}" class="user-avatar-md" />
              <div class="review-user-info">
                <div class="review-user-name">${req.nombreUsuario}</div>
                <div class="review-user-role">
                  <span>${req.tipoRol === 'productor' ? 'Productor' : 'Repartidor'} • ${req.datosRepartidor?.departamento || 'Nicaragua'}</span>
                </div>
              </div>
            </div>
            ${statusBadge}
          </div>
          <div class="review-description-box" style="margin-top: 10px;">
            ${req.descripcionCorta || 'Solicitud de verificación en AgroTrade.'}
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 12px;">
            <div style="font-size: 0.8rem; color: var(--text-secondary);">
              <strong>Cédula:</strong> ${req.datosRepartidor?.numeroCedula || 'N/A'}
            </div>
            <button class="btn btn-approve" style="padding: 6px 16px; font-size: 0.82rem;" onclick="deliveryManager.openReviewModal(${req.idSolicitud})">
              <span>Inspeccionar</span>
            </button>
          </div>
        </div>
      `;
    }).join('');
  }

  renderCatalogView() {
    const categoriesContainer = document.getElementById('catalogCategoriesList');
    if (!categoriesContainer) return;

    const categories = [
      { id: 1, name: "Granos Básicos", icon: "🌾", count: 28, desc: "Maíz, frijol rojo, arroz y sorgo" },
      { id: 2, name: "Hortalizas y Verduras", icon: "🥦", count: 45, desc: "Tomates, cebollas, chiltomas y lechugas" },
      { id: 3, name: "Frutas Frescas", icon: "🥑", count: 32, desc: "Aguacates, plátanos, cítricos y piñas" },
      { id: 4, name: "Lácteos y Derivados", icon: "🧀", count: 19, desc: "Quesos artesanales, crema y leche pura" },
      { id: 5, name: "Café y Cacao Especial", icon: "☕", count: 14, desc: "Café de altura y cacao criollo fino de aroma" },
      { id: 6, name: "Miel y Derivados", icon: "🍯", count: 8, desc: "Miel pura orgánica y polen multifloral" }
    ];

    categoriesContainer.innerHTML = categories.map(cat => `
      <div style="background: #ffffff; border: 1px solid var(--border-light); border-radius: var(--radius-lg); padding: 20px; display: flex; flex-direction: column; justify-content: space-between; gap: 14px; box-shadow: var(--shadow-card);">
        <div style="display: flex; align-items: flex-start; gap: 14px;">
          <span style="font-size: 2.2rem; background: var(--bg-app); padding: 10px; border-radius: var(--radius-md);">${cat.icon}</span>
          <div>
            <div style="font-weight: 800; color: var(--text-main); font-size: 1.05rem;">${cat.name}</div>
            <p style="font-size: 0.82rem; color: var(--text-secondary); margin-top: 3px;">${cat.desc}</p>
          </div>
        </div>
        <div style="display: flex; align-items: center; justify-content: space-between; border-top: 1px solid var(--border-subtle); padding-top: 12px;">
          <span style="font-size: 0.8rem; font-weight: 700; color: var(--primary);">${cat.count} productos</span>
          <button style="background: none; border: 1px solid var(--border-light); padding: 6px 14px; border-radius: var(--radius-full); font-size: 0.78rem; font-weight: 700; color: var(--text-main); cursor: pointer;" onclick="deliveryManager.showToast('Rubro seleccionado', 'success')">Gestionar</button>
        </div>
      </div>
    `).join('');
  }

  renderProfileView() {
    const user = authManager.getUser();
    const nameEl = document.getElementById('profileName');
    const emailEl = document.getElementById('profileEmail');
    const sidebarNameEl = document.getElementById('sidebarUserName');

    if (nameEl) nameEl.textContent = user.nombreCompleto || 'Administrador AgroTrade';
    if (emailEl) emailEl.textContent = user.email || 'admin@agrotrade.com';
    if (sidebarNameEl) sidebarNameEl.textContent = user.nombreCompleto || 'Admin AgroTrade';
  }
}

document.addEventListener('DOMContentLoaded', () => {
  window.app = new AgroTradeAdminApp();
  window.app.init();
});
