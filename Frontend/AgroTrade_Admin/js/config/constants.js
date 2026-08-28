
const APP_CONSTANTS = {
  STORAGE_KEYS: {
    AUTH_TOKEN: 'agrotrade_admin_token',
    AUTH_USER: 'agrotrade_admin_user',
    REQUESTS: 'agrotrade_verification_requests_v2',
    USERS: 'agrotrade_users_v2',
    CATEGORIES: 'agrotrade_categories_v2',
    ACTIVITIES: 'agrotrade_activities_v2',
    STATS: 'agrotrade_stats_v2'
  },
  DEFAULT_ADMIN: {
    id: 1,
    nombreCompleto: 'Admin AgroTrade',
    email: 'admin@agrotrade.com',
    rol: 'Super Administrador',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80'
  },
  
  INITIAL_USERS: [
    {
      id: 101,
      nombreCompleto: "Carlos Martínez",
      nombreCompletoDetalle: "Carlos Martínez Rivera",
      tipoRol: "productor",
      rolLabel: "Productor",
      isVerificado: true,
      estadoCuenta: "Activo",
      ultimoAcceso: "hace 4 horas",
      email: "carlos.martinez@agrotrade.com",
      telefono: "+505 8412 3456",
      fechaRegistro: "15 de marzo, 2024",
      direccion: "Finca La Esperanza, Camino Rural Km 4, Valle Central, Provincia de Agraria, México",
      bio: "Productor agrícola comprometido con prácticas sustentables y certificación de comercio justo. Especialista en cultivos rotativos.",
      avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      finca: {
        nombre: "Agropecuaria La Esperanza S.A.",
        ruc: "3004123456-7",
        extension: "50 Hectáreas"
      },
      documentos: {
        identidad: "https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600&auto=format&fit=crop&q=80",
        verificacion: "https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80"
      }
    },
    {
      id: 102,
      nombreCompleto: "María López",
      nombreCompletoDetalle: "María López Solórzano",
      tipoRol: "comprador",
      rolLabel: "Comprador",
      isVerificado: false,
      estadoCuenta: "Activo",
      ultimoAcceso: "hace 1 día",
      email: "maria.lopez@comprador.com",
      telefono: "+505 8899 1122",
      fechaRegistro: "10 de febrero, 2024",
      direccion: "Mercado Oriental Módulo B-12, Managua",
      bio: "Distribuidora mayorista de frutas y hortalizas frescas para cadenas de supermercados.",
      avatarUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      documentos: {}
    },
    {
      id: 103,
      nombreCompleto: "José Pérez",
      nombreCompletoDetalle: "José Daniel Pérez Gómez",
      tipoRol: "repartidor",
      rolLabel: "Repartidor",
      isVerificado: false,
      estadoCuenta: "Verificación pendiente",
      ultimoAcceso: "hace 2 días",
      email: "jose.perez@repartidor.com",
      telefono: "+505 7711 4455",
      fechaRegistro: "20 de agosto, 2024",
      direccion: "Barrio San Judas, Managua",
      bio: "Repartidor logístico con vehículo utilitario para transporte rápido y seguro de perecederos.",
      avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80",
      finca: {
        nombre: "Transportes Pérez Logística",
        ruc: "001-200994-0014L",
        extension: "Camioneta 1.5 Ton (Placa M-39201)"
      },
      documentos: {
        identidad: "https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600&auto=format&fit=crop&q=80",
        verificacion: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600&auto=format&fit=crop&q=80"
      }
    },
    {
      id: 104,
      nombreCompleto: "Ana López",
      nombreCompletoDetalle: "Ana Victoria López",
      tipoRol: "repartidor",
      rolLabel: "Repartidor",
      isVerificado: false,
      estadoCuenta: "Verificación pendiente",
      ultimoAcceso: "hace 3 horas",
      email: "ana.lopez@repartidor.com",
      telefono: "+505 8920 3344",
      fechaRegistro: "25 de agosto, 2024",
      direccion: "Carretera a Masaya Km 12, Managua",
      bio: "Actualización de documentos vehiculares y seguro de carga para el trimestre actual.",
      avatarUrl: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&auto=format&fit=crop&q=80",
      finca: {
        nombre: "Logística Express Masaya",
        ruc: "401-120593-0001M",
        extension: "Motocicleta 150cc (Placa M-88912)"
      },
      documentos: {
        identidad: "https://images.unsplash.com/photo-1589330694653-dad6bc01cf0f?w=600&auto=format&fit=crop&q=80",
        verificacion: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=600&auto=format&fit=crop&q=80"
      }
    }
  ],
  
  INITIAL_VERIFICATIONS: [
    {
      idSolicitud: 1,
      idUsuario: 101,
      nombreUsuario: "Carlos Martínez",
      tipoRol: "productor",
      rolSubtext: "Productor • Finca La Esperanza",
      fechaRelativa: "Hoy",
      descripcionCorta: "Solicita alta como productor de maíz orgánico certificado en la región norte.",
      estado: 0 
    },
    {
      idSolicitud: 2,
      idUsuario: 103,
      nombreUsuario: "José Pérez",
      tipoRol: "repartidor",
      rolSubtext: "Repartidor",
      fechaRelativa: "Hace 2 días",
      descripcionCorta: "Postulación para repartidor en ruta Managua - Masaya con camioneta propia.",
      estado: 0
    },
    {
      idSolicitud: 3,
      idUsuario: 104,
      nombreUsuario: "Ana López",
      tipoRol: "repartidor",
      rolSubtext: "Repartidor",
      fechaRelativa: "Hoy",
      descripcionCorta: "Actualización de documentos vehiculares y seguro de carga para el trimestre actual.",
      estado: 0
    }
  ],
  
  INITIAL_CATEGORIES: [
    {
      id: 1,
      nombre: "Frutas",
      descripcion: "Frutas frescas de temporada provenientes de huertos certificados.",
      conteoProductos: 14,
      icono: "apple"
    },
    {
      id: 2,
      nombre: "Cítricos",
      descripcion: "Naranjas, limones, mandarinas y toronjas de alta calidad.",
      conteoProductos: 8,
      icono: "citrus"
    },
    {
      id: 3,
      nombre: "Verduras",
      descripcion: "Hortalizas y vegetales cosechados diariamente.",
      conteoProductos: 21,
      icono: "vegetable"
    }
  ],
  
  INITIAL_ACTIVITIES: [
    { id: 1, iconType: "user", iconClass: "icon-blue-bg", title: "Nuevo productor registrado", time: "Hace 10 minutos" },
    { id: 2, iconType: "category", iconClass: "icon-gray-bg", title: "Categoría actualizada", time: "Hace 45 minutos" },
    { id: 3, iconType: "verified", iconClass: "icon-green-bg", title: "Verificación aprobada", time: "Hace 2 horas" }
  ],
  
  INITIAL_STATS: {
    usuariosRegistrados: 248,
    productores: 86,
    verificacionesPendientes: 7,
    categorias: 12
  }
};
