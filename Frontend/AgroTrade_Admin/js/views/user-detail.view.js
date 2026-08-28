

class UserDetailView {
  constructor() {
    this.currentUser = null;
  }

  onEnter(params) {
    const userId = params?.userId || 101;
    this.currentUser = adminStore.getUserById(userId) || adminStore.getUsers()[0];
    this.render();
  }

  render() {
    const u = this.currentUser;
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

    
    document.getElementById('userDetailFullName').textContent = u.nombreCompletoDetalle || u.nombreCompleto;
    document.getElementById('userDetailEmail').textContent = u.email;
    document.getElementById('userDetailPhone').textContent = u.telefono;
    document.getElementById('userDetailRegDate').textContent = u.fechaRegistro;
    document.getElementById('userDetailAddress').textContent = u.direccion;

    
    document.getElementById('userDetailStatus').textContent = u.estadoCuenta;
    document.getElementById('userDetailLastAccess').textContent = `Último acceso ${u.ultimoAcceso}`;

    
    const rolesContainer = document.getElementById('userDetailRolesContainer');
    if (rolesContainer) {
      rolesContainer.innerHTML = `<span class="badge-pill ${roleClass}">${u.rolLabel}</span>`;
    }

    
    const checkVerificationBtn = document.getElementById('btnUserReviewVerification');
    if (checkVerificationBtn) {
      const verificationReq = adminStore.getVerificationByUserId(u.id);
      checkVerificationBtn.onclick = () => {
        if (verificationReq) {
          router.navigateTo('revisar-verificacion', { idSolicitud: verificationReq.idSolicitud });
        } else {
          Toast.warning('Este usuario no tiene solicitudes de verificación pendientes.');
        }
      };
    }
  }
}

const userDetailView = new UserDetailView();
