document.addEventListener('DOMContentLoaded', async () => {
  authService.guardRoute();

  if (document.getElementById('usersCardsContainer')) {
    await initUserList();
  }

  if (document.getElementById('userDetailAvatar')) {
    await initUserDetail();
  }
});

let currentUserTab = 'todas';
let currentUserSearch = '';
let currentUserLoaded = null;

async function initUserList() {
  const params = new URLSearchParams(window.location.search);
  const initialFilter = params.get('filter');
  if (initialFilter) {
    currentUserTab = initialFilter;
  }

  const searchInput = document.getElementById('userSearchInput');
  if (searchInput) {
    searchInput.oninput = (e) => {
      currentUserSearch = e.target.value.toLowerCase().trim();
      renderUserList();
    };
  }

  const filterTabs = document.querySelectorAll('#userFilterTabs .filter-tab-pill');
  filterTabs.forEach(tab => {
    const filterValue = tab.getAttribute('data-filter');
    if (filterValue === currentUserTab) {
      tab.classList.add('active');
    } else {
      tab.classList.remove('active');
    }

    tab.onclick = async () => {
      filterTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      currentUserTab = filterValue;
      await renderUserList();
    };
  });

  await renderUserList();
}

async function renderUserList() {
  const container = document.getElementById('usersCardsContainer');
  if (!container) return;

  let users = await adminStore.getUsers();

  if (currentUserTab === 'productores') {
    users = users.filter(u => u.tipoRol === 'productor');
  } else if (currentUserTab === 'compradores') {
    users = users.filter(u => u.tipoRol === 'comprador');
  } else if (currentUserTab === 'repartidores') {
    users = users.filter(u => u.tipoRol === 'repartidor');
  }

  if (currentUserSearch) {
    users = users.filter(u => 
      u.nombreCompleto.toLowerCase().includes(currentUserSearch) ||
      u.email.toLowerCase().includes(currentUserSearch) ||
      u.rolLabel.toLowerCase().includes(currentUserSearch)
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

        <a href="usuario-detalle.html?userId=${user.id}" class="btn-outline" style="text-decoration:none;">
          <span>Ver detalle</span>
        </a>
      </div>
    `;
  }).join('');
}

async function initUserDetail() {
  const params = new URLSearchParams(window.location.search);
  const userId = parseInt(params.get('userId') || params.get('id') || '101', 10);
  const allUsers = await adminStore.getUsers();
  currentUserLoaded = allUsers.find(u => u.id === userId) || allUsers[0];

  if (!currentUserLoaded) return;
  renderUserDetailView();

  const editBtn = document.getElementById('btnOpenEditUserModal');
  if (editBtn) {
    editBtn.onclick = openEditUserModal;
  }

  const toggleStatusBtn = document.getElementById('btnToggleUserStatus');
  if (toggleStatusBtn) {
    toggleStatusBtn.onclick = async () => {
      const res = await adminStore.toggleUserStatus(currentUserLoaded.id);
      if (res.success) {
        currentUserLoaded = res.user;
        renderUserDetailView();
        Toast.success(`Estado de ${currentUserLoaded.nombreCompleto} cambiado a: ${res.newStatus}`);
      }
    };
  }

  const checkVerificationBtn = document.getElementById('btnUserReviewVerification');
  if (checkVerificationBtn) {
    const verificationReq = adminStore.getVerificationByUserId(currentUserLoaded.id);
    checkVerificationBtn.onclick = () => {
      if (verificationReq) {
        window.location.href = `revisar-verificacion.html?idSolicitud=${verificationReq.idSolicitud}`;
      } else {
        Toast.warning('Este usuario no tiene solicitudes de verificación pendientes.');
      }
    };
  }
}

function renderUserDetailView() {
  const u = currentUserLoaded;
  if (!u) return;

  const avatarEl = document.getElementById('userDetailAvatar');
  const nameEl = document.getElementById('userDetailName');
  const badgesEl = document.getElementById('userDetailBadges');
  const bioEl = document.getElementById('userDetailBio');

  if (avatarEl) avatarEl.src = u.avatarUrl || 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200';
  if (nameEl) nameEl.textContent = u.nombreCompleto;
  if (bioEl) bioEl.textContent = u.bio || 'Sin biografía disponible.';

  let roleClass = 'badge-productor';
  if (u.tipoRol === 'comprador') roleClass = 'badge-comprador';
  if (u.tipoRol === 'repartidor') roleClass = 'badge-repartidor';

  if (badgesEl) {
    badgesEl.innerHTML = `
      <span class="badge-pill ${roleClass}">${u.rolLabel}</span>
      ${u.isVerificado ? `<span class="badge-pill badge-verificado">✓ ${u.rolLabel} verificado</span>` : ''}
    `;
  }

  const fnEl = document.getElementById('userDetailFullName');
  const emEl = document.getElementById('userDetailEmail');
  const phEl = document.getElementById('userDetailPhone');
  const rdEl = document.getElementById('userDetailRegDate');
  const adEl = document.getElementById('userDetailAddress');

  if (fnEl) fnEl.textContent = u.nombreCompletoDetalle || u.nombreCompleto;
  if (emEl) emEl.textContent = u.email;
  if (phEl) phEl.textContent = u.telefono || 'No especificado';
  if (rdEl) rdEl.textContent = u.fechaRegistro || '2024';
  if (adEl) adEl.textContent = u.direccion || 'No especificada';

  const stEl = document.getElementById('userDetailStatus');
  const stDot = document.getElementById('userDetailStatusDot');
  const laEl = document.getElementById('userDetailLastAccess');
  const btnToggleText = document.getElementById('btnToggleUserStatusText');

  if (stEl) stEl.textContent = u.estadoCuenta;
  if (stDot) {
    stDot.className = u.estadoCuenta === 'Activo' ? 'status-dot-green' : 'status-dot-amber';
  }
  if (laEl) laEl.textContent = `Último acceso ${u.ultimoAcceso || 'recientemente'}`;

  if (btnToggleText) {
    btnToggleText.textContent = u.estadoCuenta === 'Activo' ? 'Suspender usuario' : 'Activar usuario';
  }

  const rolesContainer = document.getElementById('userDetailRolesContainer');
  if (rolesContainer) {
    rolesContainer.innerHTML = `<span class="badge-pill ${roleClass}">${u.rolLabel}</span>`;
  }
}

function openEditUserModal() {
  const modal = document.getElementById('editUserModal');
  if (!modal || !currentUserLoaded) return;

  const fnInput = document.getElementById('editUserFullNameInput');
  const emInput = document.getElementById('editUserEmailInput');
  const phInput = document.getElementById('editUserPhoneInput');
  const adInput = document.getElementById('editUserAddressInput');
  const bioInput = document.getElementById('editUserBioInput');

  if (fnInput) fnInput.value = currentUserLoaded.nombreCompletoDetalle || currentUserLoaded.nombreCompleto;
  if (emInput) emInput.value = currentUserLoaded.email;
  if (phInput) phInput.value = currentUserLoaded.telefono || '';
  if (adInput) adInput.value = currentUserLoaded.direccion || '';
  if (bioInput) bioInput.value = currentUserLoaded.bio || '';

  modal.classList.add('active');
}

function closeEditUserModal() {
  const modal = document.getElementById('editUserModal');
  if (modal) modal.classList.remove('active');
}

window.saveUserEditAction = async function() {
  if (!currentUserLoaded) return;

  const fn = document.getElementById('editUserFullNameInput')?.value.trim();
  const em = document.getElementById('editUserEmailInput')?.value.trim();
  const ph = document.getElementById('editUserPhoneInput')?.value.trim();
  const ad = document.getElementById('editUserAddressInput')?.value.trim();
  const bio = document.getElementById('editUserBioInput')?.value.trim();

  if (!fn || !em) {
    Toast.warning('Nombre completo y correo son requeridos.');
    return;
  }

  const res = await adminStore.updateUser(currentUserLoaded.id, {
    nombreCompleto: fn.split(' ').slice(0, 2).join(' ') || fn,
    nombreCompletoDetalle: fn,
    email: em,
    telefono: ph,
    direccion: ad,
    bio: bio
  });

  if (res.success) {
    currentUserLoaded = res.user;
    renderUserDetailView();
    closeEditUserModal();
    Toast.success('Información del usuario actualizada exitosamente.');
  }
}
