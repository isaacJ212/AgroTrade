const APP_CONSTANTS = {
  API_BASE_URL: (window.ENV && window.ENV.API_BASE_URL) ? window.ENV.API_BASE_URL : 'http://localhost:5080/api',
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
  }
};
