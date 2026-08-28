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
    }
  }

  async login(email, password) {
    
    try {
      const res = await fetch('http://localhost:5000/api/Auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
      });
      if (res.ok) {
        const data = await res.json();
        return { success: true, data };
      }
    } catch (e) {
      
    }

    if (email === 'admin@agrotrade.com' && password === 'admin123') {
      return {
        success: true,
        data: {
          token: 'mock_jwt_admin_' + Date.now(),
          user: APP_CONSTANTS.DEFAULT_ADMIN
        }
      };
    }

    return {
      success: false,
      message: 'Credenciales inválidas. Usa admin@agrotrade.com / admin123'
    };
  }
}

const authService = new AuthService();
