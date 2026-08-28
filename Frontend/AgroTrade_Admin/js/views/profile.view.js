

class ProfileView {
  onEnter() {
    const user = authService.getUser();
    const nameEl = document.getElementById('profileNameDisplay');
    const emailEl = document.getElementById('profileEmailDisplay');
    const roleEl = document.getElementById('profileRoleDisplay');

    if (nameEl) nameEl.textContent = user.nombreCompleto || 'Admin AgroTrade';
    if (emailEl) emailEl.textContent = user.email || 'admin@agrotrade.com';
    if (roleEl) roleEl.textContent = user.rol || 'Super Administrador';

    const logoutBtn = document.getElementById('btnProfileLogout');
    if (logoutBtn) {
      logoutBtn.onclick = () => authService.logout();
    }
  }
}

const profileView = new ProfileView();
