class AuthService {
  constructor() {
    this.tokenKey = APP_CONSTANTS.STORAGE_KEYS.AUTH_TOKEN;
    this.userKey = APP_CONSTANTS.STORAGE_KEYS.AUTH_USER;
  }

  isAuthenticated() {
    return !!localStorage.getItem(this.tokenKey);
  }

  getUser() {
    try {
      const u = localStorage.getItem(this.userKey);
      return u ? JSON.parse(u) : APP_CONSTANTS.DEFAULT_ADMIN;
    } catch {
      return APP_CONSTANTS.DEFAULT_ADMIN;
    }
  }

  setSession(token, user) {
    localStorage.setItem(this.tokenKey, token);
    localStorage.setItem(this.userKey, JSON.stringify(user || APP_CONSTANTS.DEFAULT_ADMIN));
    this.populateUserUI();
  }

  logout() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.userKey);
    window.location.href = 'login.html';
  }

  guardRoute() {
    const isLoginPage = window.location.pathname.endsWith('login.html');
    if (this.isAuthenticated()) {
      if (isLoginPage) window.location.href = 'index.html';
    } else {
     if (!isLoginPage) window.location.href = 'login.html';
     return;
    }
  }

  populateUserUI() {
    const user = this.getUser();
    // Sidebar user card
    const sidebarAvatar = document.querySelector('.sidebar-user-avatar');
    const sidebarName = document.querySelector('.sidebar-user-name');
    const sidebarRole = document.querySelector('.sidebar-user-role');
    // Header user dropdown
    const headerName = document.querySelector('.header-user-name');
    const headerEmail = document.querySelector('.header-user-email');
    const headerAvatar = document.querySelector('.avatar-mini');

    if (sidebarName) sidebarName.textContent = user.nombreCompleto || 'Administrador';
    if (sidebarRole) sidebarRole.textContent = user.rolLabel || 'Administrador';
    if (sidebarAvatar) sidebarAvatar.src = user.avatarUrl || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';

    if (headerName) headerName.textContent = user.nombreCompleto || 'Administrador';
    if (headerEmail) headerEmail.textContent = user.email || 'admin@agrotrade.com';
    if (headerAvatar) headerAvatar.src = user.avatarUrl || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
  }

  async login(email, password) {
    try {
      console.log('Mock LOGIN', email);
      const token = 'mock-jwt-token-12345';
      const user = {
        nombreCompleto: 'Administrador Demo',
        email: email,
        roles: ['Administrador'],
        rolLabel: 'Administrador',
        avatarUrl: `https://ui-avatars.com/api/?name=Admin&background=006E2C&color=fff`
      };
      return { success: true, data: { token, user } };
    } catch (e) {
      console.error('Error in login', e);
      return { success: false, message: 'Error de conexión.' };
    }
  }
}

const authService = new AuthService();

// Auto-populate UI on page load if authenticated
document.addEventListener('DOMContentLoaded', () => {
  if (authService.isAuthenticated()) {
    authService.populateUserUI();
  }
});
