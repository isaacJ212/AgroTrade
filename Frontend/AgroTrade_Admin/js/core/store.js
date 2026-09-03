class AdminStore {
  constructor() {
    this.init();
  }

  init() {
    
  }

  async getUsers(pageIndex = 1, pageSize = 50) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get(`/Users?pageIndex=${pageIndex}&pageSize=${pageSize}`);
        const items = (res.data && res.data.items) ? res.data.items : [];
        return {
          items: items.map(u => ({
            id: u.id,
            nombreCompleto: u.name || "Usuario",
            nombreCompletoDetalle: u.name,
            tipoRol: u.roles ? (u.roles.includes("Productor") ? "productor" : (u.roles.includes("Repartidor") ? "repartidor" : "comprador")) : "productor",
            rolLabel: u.roles ? u.roles.join(', ') : "Usuario",
            isVerificado: u.identidadVerificada,
            estadoCuenta: u.estadoCuenta || "Activo",
            email: u.email || "N/A",
            telefono: u.telefono || "N/A",
            fechaRegistro: u.fechaRegistro ? new Date(u.fechaRegistro).toLocaleDateString() : 'N/A',
            direccion: u.direccionBase || "N/A",
            avatarUrl: null
          })),
          totalCount: res.data.totalRegisters || items.length
        };
      }
      return { items: [], totalCount: 0 };
    } catch {
      return { items: [], totalCount: 0 };
    }
  }

  async getUserById(id) {
    const data = await this.getUsers(1, 1000);
    return data.items.find(u => u.id === Number(id));
  }

  async updateUser(id, updatedData) {
    const data = await this.getUsers(1, 1000);
    const index = data.items.findIndex(u => u.id === Number(id));
    if (index === -1) return { success: false, message: 'Usuario no encontrado' };

    users[index] = { ...users[index], ...updatedData };
    localStorage.setItem(APP_CONSTANTS.STORAGE_KEYS.USERS, JSON.stringify(users));

    this.addActivity(`Perfil de usuario actualizado: ${users[index].nombreCompleto}`, 'user', 'icon-blue-bg');
    return { success: true, user: users[index] };
  }

  async toggleUserStatus(id) {
    try {
      if (typeof apiService !== 'undefined') {
        
        return { success: true, user: { id: id, nombreCompleto: "Usuario" }, newStatus: "Suspendido" };
      }
    } catch {
      return { success: false, message: 'Error' };
    }
  }

  async getVerifications(pageIndex = 1, pageSize = 50) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get(`/DeliveryJobRequest?pageIndex=${pageIndex}&pageSize=${pageSize}`);
        const items = (res.data && res.data.items) ? res.data.items : (res.items || res.data || []);
        return items.map ? items.map(job => ({
          idSolicitud: job.id,
          idUsuario: job.usuarioId || job.repartidorId || job.id,
          nombreUsuario: job.nombreRepartidor || "Repartidor",
          tipoRol: "repartidor",
          rolSubtext: "Repartidor",
          fechaRelativa: job.fechaCreacion ? new Date(job.fechaCreacion).toLocaleDateString() : 'Reciente',
          descripcionCorta: `Solicitud de repartidor. Vehículo: ${job.tipoVehiculo || 'No especificado'}`,
          estado: job.estado === 'Pendiente' ? 0 : (job.estado === 'Aprobada' ? 1 : 2)
        })) : [];
      }
      return [];
    } catch(e) {
      console.error("Error loading verifications", e);
      return [];
    }
  }

  async getVerificationById(id) {
    const list = await this.getVerifications();
    return list.find(v => v.idSolicitud === Number(id));
  }

  async getVerificationByUserId(userId) {
    const list = await this.getVerifications();
    return list.find(v => v.idUsuario === Number(userId));
  }

  async getPendingVerifications() {
    const list = await this.getVerifications();
    return list.filter(v => v.estado === 0);
  }

  async approveVerification(idSolicitud, comment = '') {
    try {
      if (typeof apiService !== 'undefined') {
        await apiService.patch(`/DeliveryJobRequest/review/${idSolicitud}`, { estado: 1, comentario: comment });
        this.addActivity(`Verificación aprobada ID: ${idSolicitud}`, 'verified', 'icon-green-bg');
        return { success: true };
      }
    } catch(e) {
      console.error("Error approving verification", e);
      return { success: false, message: 'Error al aprobar solicitud' };
    }
  }

  async rejectVerification(idSolicitud, comment = '') {
    try {
      if (typeof apiService !== 'undefined') {
        await apiService.patch(`/DeliveryJobRequest/review/${idSolicitud}`, { estado: 2, comentario: comment });
        this.addActivity(`Verificación rechazada ID: ${idSolicitud}`, 'alert', 'icon-gray-bg');
        return { success: true };
      }
    } catch(e) {
      console.error("Error rejecting verification", e);
      return { success: false, message: 'Error al rechazar solicitud' };
    }
  }

  async getCategories(pageIndex = 1, pageSize = 50) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get(`/Categorias?pageIndex=${pageIndex}&pageSize=${pageSize}`);
        const items = (res.data && res.data.items) ? res.data.items : [];
        return {
          items: items.map(cat => ({
            id: cat.idCategoria,
            nombre: cat.nombre,
            descripcion: '',
            conteoProductos: 0 
          })),
          totalCount: res.data.totalRegisters || items.length
        };
      }
      return { items: [], totalCount: 0 };
    } catch(e) {
      console.error("Error loading categories", e);
      return { items: [], totalCount: 0 };
    }
  }

  async getCategoryById(id) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get(`/Categorias/${id}`);
        const data = res.data || res;
        if (data) {
          return {
            id: data.idCategoria,
            nombre: data.nombre,
            descripcion: '',
            conteoProductos: 0
          };
        }
        return null;
      }
    } catch(e) {
      console.error("Error loading category", e);
      return null;
    }
  }

  async addCategory(category) {
    try {
      if (typeof apiService !== 'undefined') {
   
        await apiService.post('/Categorias', { nombre: category.nombre });
        this.addActivity(`Nueva categoría creada: ${category.nombre}`, 'category', 'icon-gray-bg');
        return true;
      }
    } catch(e) {
      console.error("Error creating category", e);
      return false;
    }
  }

  async updateCategory(id, updatedData) {
    try {
      if (typeof apiService !== 'undefined') {
        await apiService.put(`/Categorias/${id}`, { nombre: updatedData.nombre });
        this.addActivity(`Categoría actualizada: ${updatedData.nombre}`, 'category', 'icon-gray-bg');
        return { success: true };
      }
    } catch(e) {
      console.error("Error updating category", e);
      return { success: false, message: 'Error al actualizar categoría' };
    }
  }

  async deleteCategory(id) {
    try {
      if (typeof apiService !== 'undefined') {
        await apiService.delete(`/Categorias/${id}`);
        this.addActivity(`Categoría eliminada`, 'category', 'icon-gray-bg');
      }
    } catch(e) {
      console.error("Error deleting category", e);
    }
  }

  getActivities() {
   
    return [];
  }

  addActivity(title, iconType = 'user', iconClass = 'icon-blue-bg') {
 
  }

  async getStats() {
    try {
      const [usersRes, catsRes, verifRes] = await Promise.all([
        this.getUsers(1, 1),
        this.getCategories(1, 1),
        this.getVerifications(1, 1)
      ]);

      const pendingVerifs = await this.getPendingVerifications();

      return {
        usuariosRegistrados: usersRes.totalCount || 0,
        productores: 0, 
        verificacionesPendientes: pendingVerifs.length || verifRes.totalCount || 0,
        categorias: catsRes.totalCount || 0
      };
    } catch(e) {
      console.error("Error getting stats", e);
      return {
        usuariosRegistrados: 0,
        productores: 0,
        verificacionesPendientes: 0,
        categorias: 0
      };
    }
  }
}

const adminStore = new AdminStore();
