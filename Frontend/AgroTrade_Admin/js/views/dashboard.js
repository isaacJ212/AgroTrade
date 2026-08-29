document.addEventListener('DOMContentLoaded', () => {
  
  authService.guardRoute();

  renderStats();
  renderPendingList();
  renderRecentActivities();
});

function renderStats() {
  const stats = adminStore.getStats();
  const pendingList = adminStore.getPendingVerifications();

  const usersEl = document.getElementById('dashStatUsers');
  const producersEl = document.getElementById('dashStatProducers');
  const pendingEl = document.getElementById('dashStatPending');
  const categoriesEl = document.getElementById('dashStatCategories');

  if (usersEl) usersEl.textContent = stats.usuariosRegistrados;
  if (producersEl) producersEl.textContent = stats.productores;
  if (pendingEl) pendingEl.textContent = pendingList.length;
  if (categoriesEl) categoriesEl.textContent = stats.categorias;
}

function renderPendingList() {
  const container = document.getElementById('dashPendingReviewsList');
  if (!container) return;

  const pending = adminStore.getPendingVerifications();

  if (pending.length === 0) {
    container.innerHTML = `
      <div style="text-align:center; padding: 24px; background:#fff; border-radius:var(--radius-lg); border:1px dashed var(--border-light); color:var(--text-secondary);">
        <div style="font-weight:700; color:var(--text-main);">¡Todo al día!</div>
        <div style="font-size:0.8rem; margin-top:4px;">No hay verificaciones pendientes de revisión.</div>
      </div>
    `;
    return;
  }

  container.innerHTML = pending.map(item => {
    const user = adminStore.getUserById(item.idUsuario) || {};
    const isProductor = item.tipoRol === 'productor';
    const roleIcon = isProductor
      ? `<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><circle cx="6" cy="18" r="3"></circle><circle cx="18" cy="18" r="3"></circle><path d="M3 18h12v-6H8l-2 3H3"></path><path d="M14 9V4h-4"></path></svg>`
      : `<svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>`;

    return `
      <div class="applicant-review-card">
        <div class="applicant-profile-group">
          <img src="${user.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150'}" alt="${item.nombreUsuario}" class="applicant-avatar-round" />
          <div>
            <div class="applicant-name-title">${item.nombreUsuario}</div>
            <div class="applicant-role-tag">
              ${roleIcon}
              <span>${isProductor ? 'Productor' : 'Repartidor'}</span>
            </div>
          </div>
        </div>

        <div class="applicant-summary-box">
          ${item.descripcionCorta}
        </div>

        <a href="revisar-verificacion.html?idSolicitud=${item.idSolicitud}" class="btn-primary" style="text-decoration:none;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path>
            <rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect>
            <path d="m9 14 2 2 4-4"></path>
          </svg>
          <span>Revisar</span>
        </a>
      </div>
    `;
  }).join('');
}

function renderRecentActivities() {
  const list = document.getElementById('dashRecentActivitiesList');
  if (!list) return;

  const activities = adminStore.getActivities();

  list.innerHTML = activities.map(act => {
    let iconSvg = '';
    if (act.iconType === 'user') {
      iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="8.5" cy="7" r="4"></circle><line x1="20" y1="8" x2="20" y2="14"></line><line x1="23" y1="11" x2="17" y2="11"></line></svg>`;
    } else if (act.iconType === 'category') {
      iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>`;
    } else {
      iconSvg = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`;
    }

    return `
      <li class="recent-activity-item">
        <div class="activity-icon-bubble ${act.iconClass}">
          ${iconSvg}
        </div>
        <div class="activity-text-info">
          <div class="activity-event-name">${act.title}</div>
          <div class="activity-event-time">${act.time}</div>
        </div>
      </li>
    `;
  }).join('');
}
