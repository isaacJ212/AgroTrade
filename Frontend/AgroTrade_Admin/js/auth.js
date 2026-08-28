class AuthManager {
  constructor() {
    this.tokenKey = CONFIG.STORAGE_KEYS.AUTH_TOKEN;
    this.userKey = CONFIG.STORAGE_KEYS.AUTH_USER;
  }

  isAuthenticated() {
    return !!localStorage.getItem(this.tokenKey);
  }

  getUser() {
    try {
      const user = localStorage.getItem(this.userKey);
      return user ? JSON.parse(user) : CONFIG.DEFAULT_ADMIN;
    } catch {
      return CONFIG.DEFAULT_ADMIN;
    }
  }

  setSession(token, user) {
    localStorage.setItem(this.tokenKey, token);
    localStorage.setItem(this.userKey, JSON.stringify(user || CONFIG.DEFAULT_ADMIN));
  }

  logout() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.userKey);
    window.location.href = 'login.html';
  }

  
  guardRoute() {
    const isLoginPage = window.location.pathname.endsWith('login.html');
    
    if (this.isAuthenticated()) {
      if (isLoginPage) {
        window.location.href = 'index.html';
      }
    } else {
      if (!isLoginPage) {
        window.location.href = 'login.html';
      }
    }
  }


  initLoginForm() {
    const form = document.getElementById('loginForm');
    if (!form) return;

    const emailInput = document.getElementById('emailInput');
    const passwordInput = document.getElementById('passwordInput');
    const togglePwdBtn = document.getElementById('togglePasswordBtn');
    const alertBox = document.getElementById('authAlert');
    const submitBtn = document.getElementById('submitLoginBtn');
    const demoFillBtn = document.getElementById('demoFillBtn');


    if (togglePwdBtn && passwordInput) {
      togglePwdBtn.addEventListener('click', () => {
        const isPassword = passwordInput.getAttribute('type') === 'password';
        passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
        togglePwdBtn.innerHTML = isPassword 
          ? `<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>`
          : `<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>`;
      });
    }


    if (demoFillBtn) {
      demoFillBtn.addEventListener('click', () => {
        if (emailInput) emailInput.value = 'admin@agrotrade.com';
        if (passwordInput) passwordInput.value = 'admin123';
        if (alertBox) alertBox.classList.add('hidden');
      });
    }

 
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      const email = emailInput.value.trim();
      const password = passwordInput.value.trim();

      if (!email || !password) {
        this.showAlert(alertBox, 'Por favor completa todos los campos', 'error');
        return;
      }

      submitBtn.disabled = true;
      submitBtn.innerHTML = `<span>Iniciando sesión...</span>`;

      try {
        const result = await apiService.login(email, password);
        if (result.success) {
          this.showAlert(alertBox, '¡Acceso concedido! Redirigiendo...', 'success');
          this.setSession(result.data.token, result.data.user);
          setTimeout(() => {
            window.location.href = 'index.html';
          }, 600);
        } else {
          this.showAlert(alertBox, result.message || 'Error al iniciar sesión', 'error');
          submitBtn.disabled = false;
          submitBtn.innerHTML = `<span>Ingresar al Panel</span>`;
        }
      } catch (err) {
        this.showAlert(alertBox, 'Ocurrió un error inesperado', 'error');
        submitBtn.disabled = false;
        submitBtn.innerHTML = `<span>Ingresar al Panel</span>`;
      }
    });
  }

  showAlert(alertElement, message, type = 'error') {
    if (!alertElement) return;
    alertElement.textContent = message;
    alertElement.className = `auth-alert alert-${type}`;
    alertElement.classList.remove('hidden');
  }
}

const authManager = new AuthManager();
