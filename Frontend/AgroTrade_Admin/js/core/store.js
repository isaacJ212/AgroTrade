class AdminStore {
  constructor() {
    this.init();
  }

  init() {
    
  }

  async getUsers() {
    try {
      if (typeof apiService !== 'undefined') {
        
        const res = await apiService.get('/Proveedores');
        const items = res.data || res || [];
        return items.map(p => ({
          id: p.id,
          nombreCompleto: p.nombreProveedor || "Productor",
          nombreCompletoDetalle: p.nombreProveedor,
          tipoRol: "productor",
          rolLabel: "Productor",
          isVerificado: true,
          estadoCuenta: "Activo",
          email: p.idUsuario ? `usuario${p.idUsuario}@agrotrade.com` : "N/A",
          telefono: "N/A",
          finca: { nombre: p.nombreFinca || 'N/A' },
          avatarUrl: p.fotoPerfil || null
        }));
      }
      return [];
    } catch {
      return [];
    }
  }

  async getUserById(id) {
    const users = await this.getUsers();
    return users.find(u => u.id === Number(id));
  }

  async updateUser(id, updatedData) {
    const users = await this.getUsers();
    const index = users.findIndex(u => u.id === Number(id));
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

  async getVerifications() {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get('/DeliveryJobRequest?pageSize=50');
        const items = res.items || res.data || res || [];
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
        await apiService.patch(`/DeliveryJobRequest/review/${idSolicitud}`, { estado: 'Aprobada', comentario: comment });
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
        await apiService.patch(`/DeliveryJobRequest/review/${idSolicitud}`, { estado: 'Rechazada', comentario: comment });
        this.addActivity(`Verificación rechazada ID: ${idSolicitud}`, 'alert', 'icon-gray-bg');
        return { success: true };
      }
    } catch(e) {
      console.error("Error rejecting verification", e);
      return { success: false, message: 'Error al rechazar solicitud' };
    }
  }

  async getCategories() {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get('/Categorias');
        const items = res.data || res || [];
        return items.map(cat => ({
          id: cat.idCategoria,
          nombre: cat.nombre,
          descripcion: '',
          conteoProductos: 0 
        }));
      }
      return [];
    } catch(e) {
      console.error("Error loading categories", e);
      return [];
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

  getStats() {
    return {
      usuariosRegistrados: 0,
      productores: 0,
      verificacionesPendientes: 0,
      categorias: 0
    };
  }
}

const adminStore = new AdminStore();
