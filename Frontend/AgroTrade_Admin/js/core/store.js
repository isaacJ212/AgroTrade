class AdminStore {
  constructor() {
    this.init();
  }

  init() {
    if (!localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.USERS)) {
      localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.USERS, JSON.stringify(APP_CONSTANTS.INITIAL_USERS));
    }
    if (!localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.REQUESTS)) {
      localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.REQUESTS, JSON.stringify(APP_CONSTANTS.INITIAL_VERIFICATIONS));
    }
    if (!localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.CATEGORIES)) {
      localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.CATEGORIES, JSON.stringify(APP_CONSTANTS.INITIAL_CATEGORIES));
    }
    if (!localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.ACTIVITIES)) {
      localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.ACTIVITIES, JSON.stringify(APP_CONSTANTS.INITIAL_ACTIVITIES));
    }
    if (!localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.STATS)) {
      localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.STATS, JSON.stringify(APP_CONSTANTS.INITIAL_STATS));
    }
  }

  getUsers() {
    try {
      const data = localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.USERS);
      return data ? JSON.parse(data) : APP_CONSTANTS.INITIAL_USERS;
    } catch {
      return APP_CONSTANTS.INITIAL_USERS;
    }
  }

  getUserById(id) {
    return this.getUsers().find(u => u.id === Number(id));
  }

  getVerifications() {
    try {
      const data = localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.REQUESTS);
      return data ? JSON.parse(data) : APP_CONSTANTS.INITIAL_VERIFICATIONS;
    } catch {
      return APP_CONSTANTS.INITIAL_VERIFICATIONS;
    }
  }

  getVerificationById(id) {
    return this.getVerifications().find(v => v.idSolicitud === Number(id));
  }

  getVerificationByUserId(userId) {
    return this.getVerifications().find(v => v.idUsuario === Number(userId));
  }

  getPendingVerifications() {
    return this.getVerifications().filter(v => v.estado === 0);
  }

  approveVerification(idSolicitud, comment = '') {
    const list = this.getVerifications();
    const req = list.find(v => v.idSolicitud === Number(idSolicitud));
    if (!req) return { success: false, message: 'Solicitud no encontrada' };

    req.estado = 1; 
    req.comentario = comment;
    req.fechaResolucion = new Date().toISOString();
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.REQUESTS, JSON.stringify(list));

    const users = this.getUsers();
    const user = users.find(u => u.id === req.idUsuario);
    if (user) {
      user.isVerificado = true;
      user.estadoCuenta = 'Activo';
      localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.USERS, JSON.stringify(users));
    }

    this.addActivity(`Verificación aprobada: ${req.nombreUsuario}`, 'verified', 'icon-green-bg');

    const stats = this.getStats();
    if (stats.verificacionesPendientes > 0) stats.verificacionesPendientes -= 1;
    if (req.tipoRol === 'productor') stats.productores += 1;
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.STATS, JSON.stringify(stats));

    return { success: true, request: req };
  }

  rejectVerification(idSolicitud, comment = '') {
    const list = this.getVerifications();
    const req = list.find(v => v.idSolicitud === Number(idSolicitud));
    if (!req) return { success: false, message: 'Solicitud no encontrada' };

    req.estado = 2; 
    req.comentario = comment;
    req.fechaResolucion = new Date().toISOString();
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.REQUESTS, JSON.stringify(list));

    this.addActivity(`Solicitud rechazada: ${req.nombreUsuario}`, 'alert', 'icon-gray-bg');

    const stats = this.getStats();
    if (stats.verificacionesPendientes > 0) stats.verificacionesPendientes -= 1;
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.STATS, JSON.stringify(stats));

    return { success: true, request: req };
  }

  getCategories() {
    try {
      const data = localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.CATEGORIES);
      return data ? JSON.parse(data) : APP_CONSTANTS.INITIAL_CATEGORIES;
    } catch {
      return APP_CONSTANTS.INITIAL_CATEGORIES;
    }
  }

  addCategory(category) {
    const categories = this.getCategories();
    const newCategory = {
      id: Date.now(),
      nombre: category.nombre,
      descripcion: category.descripcion || '',
      conteoProductos: 0,
      icono: category.icono || 'apple'
    };
    categories.push(newCategory);
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.CATEGORIES, JSON.stringify(categories));

    const stats = this.getStats();
    stats.categorias = categories.length;
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.STATS, JSON.stringify(stats));

    this.addActivity(`Nueva categoría creada: ${newCategory.nombre}`, 'category', 'icon-gray-bg');
    return newCategory;
  }

  deleteCategory(id) {
    let categories = this.getCategories();
    categories = categories.filter(c => c.id !== Number(id));
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.CATEGORIES, JSON.stringify(categories));

    const stats = this.getStats();
    stats.categorias = categories.length;
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.STATS, JSON.stringify(stats));

    this.addActivity(`Categoría eliminada`, 'category', 'icon-gray-bg');
  }

  getActivities() {
    try {
      const data = localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.ACTIVITIES);
      return data ? JSON.parse(data) : APP_CONSTANTS.INITIAL_ACTIVITIES;
    } catch {
      return APP_CONSTANTS.INITIAL_ACTIVITIES;
    }
  }

  addActivity(title, iconType = 'user', iconClass = 'icon-blue-bg') {
    const list = this.getActivities();
    list.unshift({
      id: Date.now(),
      iconType,
      iconClass,
      title,
      time: 'Hace un momento'
    });
    if (list.length > 10) list.pop();
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.ACTIVITIES, JSON.stringify(list));
  }

  getStats() {
    try {
      const data = localStorage.getItem(APP_CONSTANTS.STORAGE_KEYS.STATS);
      return data ? JSON.parse(data) : APP_CONSTANTS.INITIAL_STATS;
    } catch {
      return APP_CONSTANTS.INITIAL_STATS;
    }
  }
}

const adminStore = new AdminStore();
