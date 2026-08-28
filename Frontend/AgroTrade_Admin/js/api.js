

class ApiService {
  constructor() {
    this.baseUrl = CONFIG.API_BASE_URL;
  }

  getHeaders() {
    const token = localStorage.getItem(CONFIG.STORAGE_KEYS.AUTH_TOKEN);
    const headers = {
      'Content-Type': 'application/json'
    };
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
  }

  
  async login(email, password) {
    try {
      const response = await fetch(`${this.baseUrl}/Auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password })
      });

      if (response.ok) {
        const data = await response.json();
        return { success: true, data };
      }
    } catch (e) {
      console.warn('API backend no disponible, usando autenticación demo local:', e);
    }

    
    if (email === 'admin@agrotrade.com' && password === 'admin123') {
      const demoToken = 'mock_jwt_token_admin_' + Date.now();
      return {
        success: true,
        data: {
          token: demoToken,
          user: CONFIG.DEFAULT_ADMIN
        }
      };
    }

    return {
      success: false,
      message: 'Credenciales inválidas. Usa admin@agrotrade.com / admin123'
    };
  }

  
  async getPendingDeliveryRequests(pageIndex = 1, pageSize = 8) {
    try {
      const response = await fetch(`${this.baseUrl}/DeliveryJobRequest?pageIndex=${pageIndex}&pageSize=${pageSize}`, {
        headers: this.getHeaders()
      });
      if (response.ok) {
        const result = await response.json();
        return { success: true, data: result.data };
      }
    } catch (e) {
      
    }

    return {
      success: true,
      data: {
        items: store.getPendingRequests(),
        totalCount: store.getPendingRequests().length
      }
    };
  }

  
  async reviewDeliveryRequest(idSolicitud, estado, comentario) {
    try {
      const response = await fetch(`${this.baseUrl}/DeliveryJobRequest/review/${idSolicitud}`, {
        method: 'PATCH',
        headers: this.getHeaders(),
        body: JSON.stringify({ estado, comentario })
      });
      if (response.ok) {
        const result = await response.json();
        store.reviewRequest(idSolicitud, estado, comentario);
        return { success: true, data: result };
      }
    } catch (e) {
      
    }

    const localResult = store.reviewRequest(idSolicitud, estado, comentario);
    return localResult;
  }
}

const apiService = new ApiService();
