const MOCK_DATA = {
  users: [
    { Id: 1, Name: 'Admin Principal', Roles: ['Administrador'], IdentidadVerificada: true, EstadoCuenta: 'Activo', Email: 'admin@agrotrade.com', Telefono: '8888-1111', FechaRegistro: '2023-01-01T10:00:00Z', DireccionBase: 'Managua Central', avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150' },
    { Id: 2, Name: 'Hacienda El Sol (Juan Pérez)', Roles: ['Productor'], IdentidadVerificada: true, EstadoCuenta: 'Activo', Email: 'juan@elsol.com', Telefono: '7777-2222', FechaRegistro: '2023-05-15T08:30:00Z', DireccionBase: 'Estelí, Finca Norte', avatarUrl: 'https://images.unsplash.com/photo-1550525811-e5869dd03032?w=150' },
    { Id: 3, Name: 'Carlos Repartidor Express', Roles: ['Repartidor'], IdentidadVerificada: true, EstadoCuenta: 'Activo', Email: 'carlos@reparto.com', Telefono: '6666-3333', FechaRegistro: '2023-08-20T14:15:00Z', DireccionBase: 'León Centro', avatarUrl: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150' },
    { Id: 4, Name: 'Finca La Esperanza', Roles: ['Productor'], IdentidadVerificada: true, EstadoCuenta: 'Activo', Email: 'esperanza@finca.com', Telefono: '7777-4444', FechaRegistro: '2023-09-10T09:00:00Z', DireccionBase: 'Matagalpa', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150' },
    { Id: 5, Name: 'Maria Fernanda Compradora', Roles: ['Comprador'], IdentidadVerificada: false, EstadoCuenta: 'Activo', Email: 'mariaf@gmail.com', Telefono: '8888-5555', FechaRegistro: '2023-09-12T16:45:00Z', DireccionBase: 'Managua', avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150' },
    { Id: 6, Name: 'Roberto Delivery', Roles: ['Repartidor'], IdentidadVerificada: false, EstadoCuenta: 'Activo', Email: 'roberto@delivery.com', Telefono: '5555-6666', FechaRegistro: '2023-10-01T11:20:00Z', DireccionBase: 'Masaya', avatarUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=150' },
    { Id: 7, Name: 'Cooperativa Tierra Fértil', Roles: ['Productor'], IdentidadVerificada: true, EstadoCuenta: 'Activo', Email: 'tierrafertil@coop.com', Telefono: '7777-7777', FechaRegistro: '2023-10-05T07:10:00Z', DireccionBase: 'Jinotega', avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150' },
    { Id: 8, Name: 'Supermercados La Colonia', Roles: ['Comprador'], IdentidadVerificada: true, EstadoCuenta: 'Activo', Email: 'compras@lacolonia.com', Telefono: '2222-8888', FechaRegistro: '2023-10-10T10:30:00Z', DireccionBase: 'Managua', avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150' },
    { Id: 9, Name: 'Distribuidora del Norte', Roles: ['Comprador'], IdentidadVerificada: true, EstadoCuenta: 'Suspendido', Email: 'norte@distribuidora.com', Telefono: '2222-9999', FechaRegistro: '2023-10-15T15:00:00Z', DireccionBase: 'Estelí', avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150' },
    { Id: 10, Name: 'Pedro Logística', Roles: ['Repartidor'], IdentidadVerificada: false, EstadoCuenta: 'Activo', Email: 'pedro@logistica.com', Telefono: '5555-0000', FechaRegistro: '2023-10-20T12:00:00Z', DireccionBase: 'Granada', avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150' }
  ],
  verifications: [
    { IdSolicitud: 1, IdUsuario: 6, NombreUsuario: 'Roberto Delivery', FechaSolicitud: '2023-10-02T10:00:00Z', Estado: 'Pendiente', DatosRepartidor: { TipoVehiculo: 'Motocicleta', MarcaVehiculo: 'Yamaha YBR', PlacaVehiculo: 'M150234', NumeroCedula: '001-123456-0000A', Municipio: 'Masaya', Departamento: 'Masaya', UrlFotoPerfil: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=150', UrlFotoCedula: 'https://via.placeholder.com/300', UrlLicencia: 'https://via.placeholder.com/300' } },
    { IdSolicitud: 2, IdUsuario: 10, NombreUsuario: 'Pedro Logística', FechaSolicitud: '2023-10-21T08:30:00Z', Estado: 'Pendiente', DatosRepartidor: { TipoVehiculo: 'Camión Ligero', MarcaVehiculo: 'Kia Bongo', PlacaVehiculo: 'GR23456', NumeroCedula: '201-654321-0000B', Municipio: 'Granada', Departamento: 'Granada', UrlFotoPerfil: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150' } },
    { IdSolicitud: 3, IdUsuario: 3, NombreUsuario: 'Carlos Repartidor Express', FechaSolicitud: '2023-08-25T11:00:00Z', Estado: 'Aprobada', DatosRepartidor: { TipoVehiculo: 'Motocicleta', MarcaVehiculo: 'Honda', PlacaVehiculo: 'LE34567', NumeroCedula: '281-111111-1111C', Municipio: 'León', Departamento: 'León', UrlFotoPerfil: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150' } }
  ],
  categories: [
    { IdCategoria: 1, Nombre: 'Frutas Tropicales', Descripcion: 'Piñas, Mangos, Papayas, Bananos', ConteoProductos: 45 },
    { IdCategoria: 2, Nombre: 'Vegetales Frescos', Descripcion: 'Tomates, Cebollas, Chiltomas, Zanahorias', ConteoProductos: 82 },
    { IdCategoria: 3, Nombre: 'Granos Básicos', Descripcion: 'Frijoles, Arroz, Maíz, Sorgo', ConteoProductos: 120 },
    { IdCategoria: 4, Nombre: 'Café y Cacao', Descripcion: 'Café oro, Cacao en grano', ConteoProductos: 34 },
    { IdCategoria: 5, Nombre: 'Lácteos Artesanales', Descripcion: 'Queso, Crema, Cuajada', ConteoProductos: 18 },
    { IdCategoria: 6, Nombre: 'Tubérculos', Descripcion: 'Yuca, Quequisque, Papa, Malanga', ConteoProductos: 27 }
  ],
  activities: [
    { Id: 1, Title: 'Cooperativa Tierra Fértil publicó 500 quintales de frijol', IconType: 'category', IconClass: 'icon-green-bg', Fecha: '2023-10-22T08:00:00Z' },
    { Id: 2, Title: 'Nuevo comprador corporativo: Supermercados La Colonia', IconType: 'user', IconClass: 'icon-blue-bg', Fecha: '2023-10-21T15:30:00Z' },
    { Id: 3, Title: 'Carlos Repartidor completó ruta #4092 (Managua - Masaya)', IconType: 'delivery', IconClass: 'icon-purple-bg', Fecha: '2023-10-21T14:00:00Z' },
    { Id: 4, Title: 'Alerta: Distribuidora del Norte suspendida por impago', IconType: 'alert', IconClass: 'icon-red-bg', Fecha: '2023-10-20T09:15:00Z' },
    { Id: 5, Title: 'Hacienda El Sol renovó su plan a Productor Pro', IconType: 'star', IconClass: 'icon-yellow-bg', Fecha: '2023-10-19T11:45:00Z' }
  ],
  planes: [
    { idPlan: 1, nombre: 'Básico', precio: 0, limiteProductos: 5, destacado: false, activo: true, descripcion: 'Ideal para pequeños productores que inician en la plataforma. Hasta 5 productos activos.' },
    { idPlan: 2, nombre: 'Pro', precio: 19.99, limiteProductos: 50, destacado: true, activo: true, descripcion: 'Para fincas medianas. Hasta 50 productos, soporte prioritario y análisis de ventas.' },
    { idPlan: 3, nombre: 'Premium', precio: 49.99, limiteProductos: 1000, destacado: false, activo: true, descripcion: 'Para cooperativas y grandes haciendas. Productos ilimitados y API de integración.' }
  ],
  transacciones: [
    { id: 1, fecha: '2023-10-19T11:45:00Z', productor: 'Hacienda El Sol', plan: 'Pro', monto: 19.99, estado: 'Completado' },
    { id: 2, fecha: '2023-10-15T09:20:00Z', productor: 'Cooperativa Tierra Fértil', plan: 'Premium', monto: 49.99, estado: 'Completado' },
    { id: 3, fecha: '2023-10-10T14:10:00Z', productor: 'Finca La Esperanza', plan: 'Pro', monto: 19.99, estado: 'Completado' },
    { id: 4, fecha: '2023-10-05T08:05:00Z', productor: 'Productor Independiente', plan: 'Básico', monto: 0.00, estado: 'Completado' }
  ],
  metrics: {
    totalSuscripcionesActivas: 254,
    ingresosMensuales: 4850.50,
    crecimientoMes: 22.5,
    tasaRetencion: 94
  }
};

class ApiService {
  constructor() {
    this.baseUrl = typeof APP_CONSTANTS !== 'undefined' ? APP_CONSTANTS.API_BASE_URL : 'http://localhost:5080/api';
    this.initMockDB();
  }
  
  initMockDB() {
    // Forzamos la actualización de MOCK_DB para que siempre tenga la data rica en la demo
    localStorage.setItem('MOCK_DB', JSON.stringify(MOCK_DATA));
  }

  getMockDB() {
    this.initMockDB();
    return JSON.parse(localStorage.getItem('MOCK_DB'));
  }

  saveMockDB(db) {
    localStorage.setItem('MOCK_DB', JSON.stringify(db));
  }

  getHeaders() {
    const headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    if (typeof authService !== 'undefined' && authService.isAuthenticated()) {
      const token = localStorage.getItem(authService.tokenKey);
      if (token) headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
  }

  async get(endpoint) {
    console.log(`Mock GET ${endpoint}`);
    const db = this.getMockDB();
    const result = (data) => Promise.resolve({ Data: data || { Items: [], TotalRegisters: 0 } });
    
    if (endpoint.includes('/Users')) {
      return result({ Items: db.users, TotalRegisters: db.users.length });
    }
    if (endpoint.includes('/DeliveryJobRequest?')) {
      return result({ Items: db.verifications, TotalRegisters: db.verifications.length });
    }
    if (endpoint.includes('/Categorias?')) {
      return result({ Items: db.categories, TotalRegisters: db.categories.length });
    }
    if (endpoint.includes('/Categorias/')) {
      const id = parseInt(endpoint.split('/').pop());
      const cat = db.categories.find(c => c.IdCategoria === id || c.idCategoria === id);
      return result(cat);
    }
    if (endpoint.includes('/Activities')) {
      return result({ Items: db.activities, TotalRegisters: db.activities.length });
    }
    if (endpoint.includes('/Suscripciones/metrics')) {
      return result(db.metrics);
    }
    if (endpoint.includes('/Suscripciones/transacciones')) {
      return result(db.transacciones);
    }
    if (endpoint.includes('/Suscripciones/planes')) {
      return result(db.planes);
    }
    if (endpoint.includes('/Suscripciones/all')) {
      // Create some mock subscriptions
      const subs = db.users.filter(u => u.Roles.includes('Productor')).map(u => ({
        nombreUsuario: u.Name,
        tipoPlan: 'Pro',
        tarifaPago: 19.99,
        fechaInicio: u.FechaRegistro,
        estado: 'Activa'
      }));
      return result(subs);
    }
    if (endpoint.includes('/Stats')) {
      return result({
        totalUsuarios: db.users.length,
        totalProductores: db.users.filter(u => u.Roles.includes('Productor')).length,
        totalVentas: 0
      });
    }
    
    return result(null);
  }

  async post(endpoint, data) {
    console.log(`Mock POST ${endpoint}`, data);
    const db = this.getMockDB();
    if (endpoint.includes('/Categorias')) {
      const newCat = { IdCategoria: Date.now(), Nombre: data.nombre, Descripcion: '', ConteoProductos: 0 };
      db.categories.push(newCat);
      this.saveMockDB(db);
      return Promise.resolve({ Data: newCat });
    }
    if (endpoint.includes('/Activities')) {
      db.activities.unshift({ Id: Date.now(), Title: data.title, IconType: data.iconType, IconClass: data.iconClass, Fecha: data.fecha });
      this.saveMockDB(db);
      return Promise.resolve({ success: true });
    }
    if (endpoint.includes('/Suscripciones/planes')) {
      const newPlan = { ...data, idPlan: Date.now() };
      db.planes.push(newPlan);
      this.saveMockDB(db);
      return Promise.resolve({ Data: newPlan });
    }
    return Promise.resolve({ success: true });
  }

  async put(endpoint, data) {
    console.log(`Mock PUT ${endpoint}`, data);
    const db = this.getMockDB();
    if (endpoint.includes('/Users/')) {
      const id = parseInt(endpoint.split('/').pop());
      const idx = db.users.findIndex(u => u.Id === id);
      if (idx !== -1) {
        db.users[idx] = { ...db.users[idx], Name: data.nombreCompleto, Email: data.email, Telefono: data.telefono, DireccionBase: data.direccion };
        this.saveMockDB(db);
        return Promise.resolve({ Data: db.users[idx] });
      }
    }
    if (endpoint.includes('/Categorias/')) {
      const id = parseInt(endpoint.split('/').pop());
      const idx = db.categories.findIndex(c => c.IdCategoria === id || c.idCategoria === id);
      if (idx !== -1) {
        db.categories[idx].Nombre = data.nombre;
        this.saveMockDB(db);
        return Promise.resolve({ success: true });
      }
    }
    if (endpoint.includes('/Suscripciones/planes')) {
      const idx = db.planes.findIndex(p => p.idPlan === data.idPlan);
      if (idx !== -1) {
        db.planes[idx] = { ...db.planes[idx], ...data };
        this.saveMockDB(db);
        return Promise.resolve({ success: true });
      }
    }
    return Promise.resolve({ success: true });
  }
  
  async patch(endpoint, data) {
    console.log(`Mock PATCH ${endpoint}`, data);
    const db = this.getMockDB();
    if (endpoint.includes('/Users/') && endpoint.includes('/status')) {
      const id = parseInt(endpoint.split('/')[2]);
      const idx = db.users.findIndex(u => u.Id === id);
      if (idx !== -1) {
        db.users[idx].EstadoCuenta = db.users[idx].EstadoCuenta === 'Activo' ? 'Suspendido' : 'Activo';
        this.saveMockDB(db);
        return Promise.resolve({ Data: db.users[idx] });
      }
    }
    if (endpoint.includes('/DeliveryJobRequest/review/')) {
      const id = parseInt(endpoint.split('/').pop());
      const idx = db.verifications.findIndex(v => v.IdSolicitud === id);
      if (idx !== -1) {
        db.verifications[idx].Estado = data.estado === 1 ? 'Aprobada' : 'Rechazada';
        this.saveMockDB(db);
        return Promise.resolve({ success: true });
      }
    }
    return Promise.resolve({ success: true });
  }

  async delete(endpoint) {
    console.log(`Mock DELETE ${endpoint}`);
    const db = this.getMockDB();
    if (endpoint.includes('/Categorias/')) {
      const id = parseInt(endpoint.split('/').pop());
      db.categories = db.categories.filter(c => c.IdCategoria !== id && c.idCategoria !== id);
      this.saveMockDB(db);
      return Promise.resolve({ success: true });
    }
    if (endpoint.includes('/Suscripciones/planes/')) {
      const id = parseInt(endpoint.split('/').pop());
      db.planes = db.planes.filter(p => p.idPlan !== id);
      this.saveMockDB(db);
      return Promise.resolve({ success: true });
    }
    return Promise.resolve({ success: true });
  }
}

const apiService = new ApiService();
