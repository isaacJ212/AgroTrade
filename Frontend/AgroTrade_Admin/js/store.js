


const INITIAL_REQUESTS = [
  {
    idSolicitud: 1,
    idUsuario: 101,
    nombreUsuario: "Carlos Martinez",
    tipoRol: "productor", 
    avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80",
    descripcionCorta: "Solicita alta como productor de maíz orgánico certificado en la región norte.",
    datosRepartidor: {
      tipoVehiculo: "Tractor / Camión Ligero",
      placaVehiculo: "AGR-9821",
      marcaVehiculo: "John Deere 5075E",
      zonaOperaciones: "Región Norte - Matagalpa",
      departamento: "Matagalpa",
      numeroCedula: "441-150485-0002K",
      bancoNombre: "BAC Credomatic",
      numeroCuenta: "3658921004",
      urlFotoPerfil: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80",
      urlFotoCedula: "https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600&auto=format&fit=crop&q=80",
      urlLicencia: "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600&auto=format&fit=crop&q=80",
      urlRecordPolicial: "https://images.unsplash.com/photo-1450133064473-71024230f91b?w=600&auto=format&fit=crop&q=80"
    },
    estado: 0, 
    fechaSolicitud: "2026-08-28T14:30:00Z"
  },
  {
    idSolicitud: 2,
    idUsuario: 102,
    nombreUsuario: "Ana López",
    tipoRol: "repartidor",
    avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80",
    descripcionCorta: "Actualización de documentos vehiculares y seguro de carga para el trimestre actual.",
    datosRepartidor: {
      tipoVehiculo: "Motocicleta 150cc",
      placaVehiculo: "M-48291",
      marcaVehiculo: "Yamaha YBR 125",
      zonaOperaciones: "Managua Centro y Carretera a Masaya",
      departamento: "Managua",
      numeroCedula: "001-200994-0014L",
      bancoNombre: "Banco Banpro",
      numeroCuenta: "1002049281902",
      urlFotoPerfil: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80",
      urlFotoCedula: "https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600&auto=format&fit=crop&q=80",
      urlLicencia: "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600&auto=format&fit=crop&q=80",
      urlRecordPolicial: "https://images.unsplash.com/photo-1450133064473-71024230f91b?w=600&auto=format&fit=crop&q=80"
    },
    estado: 0,
    fechaSolicitud: "2026-08-28T13:45:00Z"
  },
  {
    idSolicitud: 3,
    idUsuario: 103,
    nombreUsuario: "Marcos Estrada",
    tipoRol: "repartidor",
    avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80",
    descripcionCorta: "Solicitud para repartos refrigerados en ruta Estelí - Managua.",
    datosRepartidor: {
      tipoVehiculo: "Camioneta Refrigerada",
      placaVehiculo: "ES-19028",
      marcaVehiculo: "Toyota Hilux",
      zonaOperaciones: "Estelí / Jinotega / Managua",
      departamento: "Estelí",
      numeroCedula: "161-120388-0001P",
      bancoNombre: "BAC Credomatic",
      numeroCuenta: "98201948201",
      urlFotoPerfil: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80",
      urlFotoCedula: "https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600&auto=format&fit=crop&q=80",
      urlLicencia: "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600&auto=format&fit=crop&q=80",
      urlRecordPolicial: "https://images.unsplash.com/photo-1450133064473-71024230f91b?w=600&auto=format&fit=crop&q=80"
    },
    estado: 0,
    fechaSolicitud: "2026-08-28T11:20:00Z"
  }
];

const INITIAL_ACTIVITIES = [
  {
    id: 1,
    type: "user",
    iconClass: "bg-blue",
    title: "Nuevo productor registrado",
    time: "Hace 10 minutos"
  },
  {
    id: 2,
    type: "category",
    iconClass: "bg-gray",
    title: "Categoría actualizada",
    time: "Hace 45 minutos"
  },
  {
    id: 3,
    type: "verified",
    iconClass: "bg-green",
    title: "Verificación aprobada",
    time: "Hace 2 horas"
  }
];

const INITIAL_STATS = {
  registeredUsers: 248,
  registeredUsersGrowth: "+12%",
  producers: 86,
  producersGrowth: "+5%",
  pendingReviews: 7,
  categories: 12
};

class Store {
  constructor() {
    this.init();
  }

  init() {
    if (!localStorage.getItem(CONFIG.STORAGE_KEYS.REQUESTS_DATA)) {
      localStorage.setItem(CONFIG.STORAGE_KEYS.REQUESTS_DATA, JSON.stringify(INITIAL_REQUESTS));
    }
    if (!localStorage.getItem(CONFIG.STORAGE_KEYS.ACTIVITY_DATA)) {
      localStorage.setItem(CONFIG.STORAGE_KEYS.ACTIVITY_DATA, JSON.stringify(INITIAL_ACTIVITIES));
    }
    if (!localStorage.getItem(CONFIG.STORAGE_KEYS.STATS_DATA)) {
      localStorage.setItem(CONFIG.STORAGE_KEYS.STATS_DATA, JSON.stringify(INITIAL_STATS));
    }
  }

  getRequests() {
    try {
      const data = localStorage.getItem(CONFIG.STORAGE_KEYS.REQUESTS_DATA);
      return data ? JSON.parse(data) : INITIAL_REQUESTS;
    } catch {
      return INITIAL_REQUESTS;
    }
  }

  getPendingRequests() {
    return this.getRequests().filter(r => r.estado === 0);
  }

  getRequestById(id) {
    return this.getRequests().find(r => r.idSolicitud === Number(id));
  }

  getActivities() {
    try {
      const data = localStorage.getItem(CONFIG.STORAGE_KEYS.ACTIVITY_DATA);
      return data ? JSON.parse(data) : INITIAL_ACTIVITIES;
    } catch {
      return INITIAL_ACTIVITIES;
    }
  }

  getStats() {
    try {
      const data = localStorage.getItem(CONFIG.STORAGE_KEYS.STATS_DATA);
      return data ? JSON.parse(data) : INITIAL_STATS;
    } catch {
      return INITIAL_STATS;
    }
  }

  
  reviewRequest(idSolicitud, estado, comentario = "") {
    const requests = this.getRequests();
    const target = requests.find(r => r.idSolicitud === Number(idSolicitud));
    
    if (!target) return { success: false, message: "Solicitud no encontrada" };

    target.estado = Number(estado);
    target.comentarioRevision = comentario;
    target.fechaRevision = new Date().toISOString();

    localStorage.setItem(CONFIG.STORAGE_KEYS.REQUESTS_DATA, JSON.stringify(requests));

    
    const statusText = estado === 1 ? "Verificación aprobada" : "Solicitud rechazada";
    const iconClass = estado === 1 ? "bg-green" : "bg-red";
    this.addActivity(`${statusText}: ${target.nombreUsuario} (${target.tipoRol})`, iconClass);

    
    const stats = this.getStats();
    if (stats.pendingReviews > 0) {
      stats.pendingReviews -= 1;
    }
    if (estado === 1) {
      stats.registeredUsers += 1;
      if (target.tipoRol === "productor") {
        stats.producers += 1;
      }
    }
    localStorage.setItem(CONFIG.STORAGE_KEYS.STATS_DATA, JSON.stringify(stats));

    return { success: true, request: target };
  }

  addActivity(title, iconClass = "bg-blue") {
    const activities = this.getActivities();
    activities.unshift({
      id: Date.now(),
      iconClass: iconClass,
      title: title,
      time: "Hace un momento"
    });
    
    if (activities.length > 10) activities.pop();
    localStorage.setItem(CONFIG.STORAGE_KEYS.ACTIVITY_DATA, JSON.stringify(activities));
  }
}

const store = new Store();
