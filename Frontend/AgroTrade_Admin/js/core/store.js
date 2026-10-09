class AdminStore {
  constructor() {
    this.init();
  }

  init() {
    
  }

  async getUsers(pageIndex = 1, pageSize = 50, rol = null) {
    try {
      if (typeof apiService !== 'undefined') {
        let url = `/Users?pageIndex=${pageIndex}&pageSize=${pageSize}`;
        if (rol) url += `&rol=${rol}`;
        const res = await apiService.get(url);
        // Backend returns Result<PagedResponse<...>> with { StatusCode, Data: { Items, TotalRegisters, ... }, Message, IsSuccess }
        const data = res.Data || res.data;
        const items = (data && data.Items) ? data.Items : [];
        return {
          items: items.map(u => ({
            id: u.Id,
            nombreCompleto: u.Name || "Usuario",
            nombreCompletoDetalle: u.Name,
            tipoRol: u.Roles ? (u.Roles.includes("Productor") ? "productor" : (u.Roles.includes("Repartidor") ? "repartidor" : "comprador")) : "productor",
            rolLabel: u.Roles ? u.Roles.join(', ') : "Usuario",
            isVerificado: u.IdentidadVerificada,
            estadoCuenta: u.EstadoCuenta || "Activo",
            email: u.Email || "N/A",
            telefono: u.Telefono || "N/A",
            fechaRegistro: u.FechaRegistro ? new Date(u.FechaRegistro).toLocaleDateString() : 'N/A',
            direccion: u.DireccionBase || "N/A",
            avatarUrl: null
          })),
          totalCount: (data && data.TotalRegisters) ? data.TotalRegisters : items.length
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
    try {
      if (typeof apiService !== 'undefined') {
        const payload = {
          nombreCompleto: updatedData.nombreCompletoDetalle || updatedData.nombreCompleto,
          email: updatedData.email,
          telefono: updatedData.telefono,
          direccion: updatedData.direccion,
          bio: updatedData.bio
        };
        const res = await apiService.put(`/Users/${id}`, payload);
        const data = res.Data || res.data || res;
        if (data) {
          this.addActivity(`Perfil de usuario actualizado: ${payload.nombreCompleto}`, 'user', 'icon-blue-bg');
          return { 
            success: true, 
            user: {
              id: data.Id || id,
              nombreCompleto: data.Name || payload.nombreCompleto,
              nombreCompletoDetalle: data.Name || payload.nombreCompleto,
              email: data.Email || payload.email,
              telefono: data.Telefono || payload.telefono,
              direccion: data.DireccionBase || payload.direccion,
              bio: payload.bio
            } 
          };
        }
        return { success: true };
      }
      return { success: false, message: 'API no disponible' };
    } catch (e) {
      console.error("Error updating user", e);
      return { success: false, message: e.message || 'Error al actualizar usuario' };
    }
  }

  async toggleUserStatus(id) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.patch(`/Users/${id}/status`, {});
        const data = res.Data || res.data || res;
        const newStatus = data?.EstadoCuenta || data?.estadoCuenta || 'Suspendido';
        this.addActivity(`Estado de usuario cambiado a: ${newStatus}`, 'user', 'icon-blue-bg');
        return { success: true, user: { id: id }, newStatus };
      }
      return { success: false, message: 'API no disponible' };
    } catch (e) {
      console.error("Error toggling user status", e);
      return { success: false, message: e.message || 'Error al cambiar estado' };
    }
  }

  async getVerifications(pageIndex = 1, pageSize = 50) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get(`/DeliveryJobRequest?pageIndex=${pageIndex}&pageSize=${pageSize}`);
        // Backend returns Result<PagedResponse<...>> with { StatusCode, Data: { Items, TotalRegisters, ... }, Message, IsSuccess }
        const data = res.Data || res.data;
        const items = (data && data.Items) ? data.Items : [];
        return {
          items: items.map(job => {
            const d = job.DatosRepartidor || {};
            return {
              idSolicitud: job.IdSolicitud,
              idUsuario: job.IdUsuario,
              nombreUsuario: job.NombreUsuario || "Repartidor",
              tipoRol: "repartidor",
              rolSubtext: "Repartidor",
              fechaRelativa: job.FechaSolicitud ? new Date(job.FechaSolicitud).toLocaleDateString() : 'Reciente',
              descripcionCorta: `Solicitud de repartidor. Vehículo: ${d.TipoVehiculo || 'No especificado'}`,
              estado: job.Estado?.toLowerCase() === 'pendiente' ? 0 : (job.Estado?.toLowerCase() === 'aprobada' ? 1 : 2),
              // Photo URLs from backend
              fotoPerfil: d.UrlFotoPerfil || '',
              fotoCedula: d.UrlFotoCedula || '',
              recordPolicial: d.UrlRecordPolicial || '',
              licencia: d.UrlLicencia || '',
              // Additional data
              marcaVehiculo: d.MarcaVehiculo || '',
              tipoVehiculo: d.TipoVehiculo || '',
              placaVehiculo: d.PlacaVehiculo || '',
              numeroCedula: d.NumeroCedula || '',
              municipio: d.Municipio || '',
              departamento: d.Departamento || '',
              bancoNombre: d.BancoNombre || '',
              numeroCuenta: d.NumeroCuenta || ''
            };
          }),
          totalCount: (data && data.TotalRegisters) ? data.TotalRegisters : items.length
        };
      }
      return { items: [], totalCount: 0 };
    } catch(e) {
      console.error("Error loading verifications", e);
      throw e; 
    }
  }

  async getVerificationById(id) {
    const list = await this.getVerifications(1, 1000);
    return list.items.find(v => v.idSolicitud === Number(id));
  }

  async getVerificationByUserId(userId) {
    const list = await this.getVerifications(1, 1000);
    return list.items.find(v => v.idUsuario === Number(userId));
  }

  async getPendingVerifications() {
    try {
      const list = await this.getVerifications(1, 1000);
      return list.items.filter(v => v.estado === 0);
    } catch(e) {
      console.error("Error fetching pending verifications", e);
      return [];
    }
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
        const data = res.Data || res.data;
        const items = (data && data.Items) ? data.Items : [];
        return {
          items: items.map(cat => ({
            id: cat.IdCategoria || cat.idCategoria,
            nombre: cat.Nombre || cat.nombre,
            descripcion: cat.Descripcion || cat.descripcion || '',
            conteoProductos: cat.ConteoProductos || cat.conteoProductos || 0
          })),
          totalCount: (data && data.TotalRegisters) ? data.TotalRegisters : items.length
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
        const data = res.Data || res.data || res;
        if (data) {
          return {
            id: data.IdCategoria || data.idCategoria,
            nombre: data.Nombre || data.nombre,
            descripcion: data.Descripcion || data.descripcion || '',
            conteoProductos: data.ConteoProductos || data.conteoProductos || 0
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

  async getActivities(pageIndex = 1, pageSize = 20) {
    try {
      if (typeof apiService !== 'undefined') {
        const res = await apiService.get(`/Activities?pageIndex=${pageIndex}&pageSize=${pageSize}`);
        const data = res.Data || res.data;
        const items = (data && data.Items) ? data.Items : [];
        return {
          items: items.map(a => ({
            id: a.Id,
            title: a.Title || a.Titulo || a.Descripcion,
            iconType: a.IconType || a.iconType || 'user',
            iconClass: a.IconClass || a.iconClass || 'icon-blue-bg',
            time: a.Fecha ? new Date(a.Fecha).toLocaleString() : new Date().toLocaleString()
          })),
          totalCount: (data && data.TotalRegisters) ? data.TotalRegisters : items.length
        };
      }
      return { items: [], totalCount: 0 };
    } catch(e) {
      console.error("Error loading activities", e);
      return { items: [], totalCount: 0 };
    }
  }

  async addActivity(title, iconType = 'user', iconClass = 'icon-blue-bg') {
    try {
      if (typeof apiService !== 'undefined') {
        await apiService.post('/Activities', { title, iconType, iconClass, fecha: new Date().toISOString() });
      }
    } catch(e) {
      console.error("Error adding activity", e);
    }
  }

  async getStats() {
    try {
      let stats = { totalUsuarios: 0, totalProductores: 0, totalVentas: 0 };
      if (typeof apiService !== 'undefined') {
        try {
          const resStats = await apiService.get('/Stats');
          const data = resStats.Data || resStats.data || resStats;
          if (data) stats = data;
        } catch(e) {
          console.warn("Stats endpoint not available, calculating from other endpoints");
        }
      }
      const [catsRes, verifRes, usersRes, productoresRes] = await Promise.all([
        this.getCategories(1, 1),
        this.getVerifications(1, 1).catch(() => ({ totalCount: 0 })),
        this.getUsers(1, 1).catch(() => ({ totalCount: 0 })),
        this.getUsers(1, 1, 'Productor').catch(() => ({ totalCount: 0 }))
      ]);

      return {
        usuariosRegistrados: stats.totalUsuarios || usersRes.totalCount || 0,
        productores: stats.totalProductores || productoresRes.totalCount || 0,
        verificacionesPendientes: verifRes.totalCount || 0,
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
