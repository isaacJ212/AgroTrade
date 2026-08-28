

class VerificationsView {
  constructor() {
    this.currentTab = 'pendientes';
  }

  onEnter() {
    this.bindEvents();
    this.render();
  }

  bindEvents() {
    const tabs = document.querySelectorAll('#verificationsFilterTabs .filter-tab-pill');
    tabs.forEach(tab => {
      tab.onclick = () => {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        this.currentTab = tab.getAttribute('data-status');
        this.render();
      };
    });
  }

  render() {
    const container = document.getElementById('verificationsCardsContainer');
    if (!container) return;

    const all = adminStore.getVerifications();
    let filtered = all;

    if (this.currentTab === 'pendientes') {
      filtered = all.filter(v => v.estado === 0);
    } else if (this.currentTab === 'aprobadas') {
      filtered = all.filter(v => v.estado === 1);
    } else if (this.currentTab === 'rechazadas') {
      filtered = all.filter(v => v.estado === 2);
    }

    if (filtered.length === 0) {
      container.innerHTML = `
        <div style="text-align:center; padding:30px 16px; color:var(--text-secondary);">
          No hay solicitudes en esta sección.
        </div>
      `;
      return;
    }

    container.innerHTML = filtered.map(req => {
      const user = adminStore.getUserById(req.idUsuario) || {};
      const statusBadge = req.estado === 0
        ? `<span class="badge-pill badge-pendiente"><span class="status-dot-amber"></span> Pendiente</span>`
        : req.estado === 1
          ? `<span class="badge-pill badge-productor">Aprobada</span>`
          : `<span class="badge-pill" style="background:#fee2e2; color:#991b1b;">Rechazada</span>`;

      return `
        <div class="applicant-review-card">
          <div class="applicant-card-header">
            <div class="applicant-profile-group">
              <img src="${user.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'}" alt="${req.nombreUsuario}" class="applicant-avatar-round" />
              <div>
                <div class="applicant-name-title">${req.nombreUsuario}</div>
                <div style="font-size:0.8rem; color:var(--text-secondary);">${req.rolSubtext}</div>
              </div>
            </div>
            ${statusBadge}
          </div>

          <div style="display:flex; justify-content:space-between; align-items:center; border-top:1px solid var(--border-subtle); padding-top:10px;">
            <span style="font-size:0.75rem; color:var(--text-secondary);">${req.fechaRelativa}</span>
            <button class="btn-primary" style="width:auto; padding:8px 20px; font-size:0.85rem;" onclick="router.navigateTo('revisar-verificacion', { idSolicitud: ${req.idSolicitud} })">
              <span>Revisar</span>
            </button>
          </div>
        </div>
      `;
    }).join('');
  }
}

const verificationsView = new VerificationsView();
