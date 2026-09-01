class ApiService {
  constructor() {
    this.baseUrl = typeof APP_CONSTANTS !== 'undefined' ? APP_CONSTANTS.API_BASE_URL : 'http://localhost:5080/api';
  }

  getHeaders() {
    const headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    
    if (typeof authService !== 'undefined' && authService.isAuthenticated()) {
      const token = localStorage.getItem(authService.tokenKey);
      if (token) {
        headers['Authorization'] = `Bearer ${token}`;
      }
    }
    
    return headers;
  }

  async get(endpoint) {
    try {
      const res = await fetch(`${this.baseUrl}${endpoint}`, {
        method: 'GET',
        headers: this.getHeaders()
      });
      if (!res.ok) throw new Error(await res.text());
      return await res.json();
    } catch (e) {
      console.error(`Error GET ${endpoint}:`, e);
      throw e;
    }
  }

  async post(endpoint, data) {
    try {
      const res = await fetch(`${this.baseUrl}${endpoint}`, {
        method: 'POST',
        headers: this.getHeaders(),
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error(await res.text());
      const text = await res.text();
      return text ? JSON.parse(text) : null;
    } catch (e) {
      console.error(`Error POST ${endpoint}:`, e);
      throw e;
    }
  }

  async put(endpoint, data) {
    try {
      const res = await fetch(`${this.baseUrl}${endpoint}`, {
        method: 'PUT',
        headers: this.getHeaders(),
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error(await res.text());
      const text = await res.text();
      return text ? JSON.parse(text) : null;
    } catch (e) {
      console.error(`Error PUT ${endpoint}:`, e);
      throw e;
    }
  }
  
  async patch(endpoint, data) {
    try {
      const res = await fetch(`${this.baseUrl}${endpoint}`, {
        method: 'PATCH',
        headers: this.getHeaders(),
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error(await res.text());
      const text = await res.text();
      return text ? JSON.parse(text) : null;
    } catch (e) {
      console.error(`Error PATCH ${endpoint}:`, e);
      throw e;
    }
  }

  async delete(endpoint) {
    try {
      const res = await fetch(`${this.baseUrl}${endpoint}`, {
        method: 'DELETE',
        headers: this.getHeaders()
      });
      if (!res.ok) throw new Error(await res.text());
      const text = await res.text();
      return text ? JSON.parse(text) : null;
    } catch (e) {
      console.error(`Error DELETE ${endpoint}:`, e);
      throw e;
    }
  }
}

const apiService = new ApiService();
