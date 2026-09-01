/// Constantes de rutas nombradas de la app AgroTrade.
/// Todas las pantallas deben estar registradas aquí y en [AppRouter].
class AppRoutes {
  AppRoutes._();

  // ── Onboarding & Auth ─────────────────────────────────────────────────────
  static const String splash         = '/';
  static const String onboarding     = '/onboarding';
  static const String login          = '/login';
  static const String registro       = '/registro';
  static const String roleSelection  = '/role-selection';
  static const String resetPassword  = '/reset-password';
  static const String verificarCodigo = '/verificar-codigo';

  // ── Shared ────────────────────────────────────────────────────────────────
  static const String profile        = '/profile';
  static const String editarPerfil   = '/editar-perfil';
  static const String notificaciones = '/notificaciones';
  static const String centroAyuda    = '/centro-ayuda';
  static const String chat           = '/chat';

  // ── Cliente (Comprador) ───────────────────────────────────────────────────
  static const String inicioComprador         = '/comprador/inicio';
  static const String explorarProductos       = '/comprador/explorar';
  static const String buscarProductos         = '/comprador/buscar';
  static const String detalleProductoCliente  = '/comprador/producto/detalle';
  static const String perfilProductor         = '/comprador/productor/perfil';
  static const String productoresCercanos     = '/comprador/productores';
  static const String carrito                 = '/comprador/carrito';
  static const String pago                    = '/comprador/pago';
  static const String resumenConfirmacion     = '/comprador/resumen';
  static const String pedidoConfirmado        = '/comprador/pedido-confirmado';
  static const String misPedidos              = '/comprador/mis-pedidos';
  static const String detallePedidoComprador  = '/comprador/pedido/detalle';
  static const String seguimientoPedido       = '/comprador/pedido/seguimiento';
  static const String entrega                 = '/comprador/entrega';
  static const String valorarPedido           = '/comprador/valorar';
  static const String suscripciones           = '/comprador/suscripciones';
  static const String categoryScreen          = '/comprador/categoria';
  static const String rutaSeguimientoCliente  = '/comprador/pedido/ruta-mapa';
  static const String reportarProblema        = '/comprador/pedido/reportar';
  static const String formularioDireccion     = '/comprador/direccion/formulario';

  // ── Productor ─────────────────────────────────────────────────────────────
  static const String inicioProductor           = '/productor/inicio';
  static const String inventario                = '/productor/inventario';
  static const String agregarProducto           = '/productor/inventario/agregar';
  static const String detalleProductoProductor  = '/productor/inventario/detalle';
  static const String registroCosecha           = '/productor/cosecha/registro';
  static const String pedidosRecibidos          = '/productor/pedidos';
  static const String orderDetail               = '/productor/pedidos/detalle';
  static const String prepareOrder              = '/productor/pedidos/preparar';
  static const String ventas                    = '/productor/ventas';
  static const String crearOferta               = '/productor/ofertas/crear';
  static const String calculadoraPrecioJusto    = '/productor/precio-justo/calculadora';
  static const String resultadoPrecioJusto      = '/productor/precio-justo/resultado';
  static const String perfilFinca               = '/productor/finca';
  static const String mapaCalorDemanda          = '/productor/mapa-demanda';
  static const String editarFinca               = '/productor/editar-finca';
  static const String tableroImpacto            = '/productor/impacto';

  // ── Repartidor ────────────────────────────────────────────────────────────
  static const String inicioRepartidor            = '/repartidor/inicio';
  static const String entregasRepartidor          = '/repartidor/entregas';
  static const String aceptarEntregaRepartidor    = '/repartidor/entregas/aceptar';
  static const String detalleEntregaRepartidor    = '/repartidor/entregas/detalle';
  static const String recogerPedidoRepartidor     = '/repartidor/pedido/recoger';
  static const String entregaEnCursoRepartidor    = '/repartidor/pedido/en-curso';
  static const String rutaEntregaRepartidor       = '/repartidor/pedido/ruta';
  static const String confirmarEntregaRepartidor  = '/repartidor/pedido/confirmar';
}
