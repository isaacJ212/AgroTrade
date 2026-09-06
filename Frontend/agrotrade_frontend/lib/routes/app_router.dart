import 'package:flutter/material.dart';

// ── Onboarding & Auth ────────────────────────────────────────────────────────
import '../screens/shared/onboarding/splash.dart';
import '../screens/shared/onboarding/onBoarding.dart';
import '../screens/shared/auth/Login.dart';
import '../screens/shared/auth/registro.dart';
import '../screens/shared/auth/roleSelection.dart';
import '../screens/shared/auth/resetPassword.dart';
import '../screens/shared/auth/verificarCodigo.dart';

// ── Shared ────────────────────────────────────────────────────────────────────
import '../screens/shared/profile.dart';
import '../screens/shared/editarPerfil.dart';
import '../screens/shared/notificaciones.dart';
import '../screens/shared/centroAyuda.dart';
import '../screens/shared/chat_screen.dart';

// ── AgroBot ───────────────────────────────────────────────────────────────────
import '../screens/shared/agrobot/agrobot_welcome.dart';
import '../screens/shared/agrobot/agrobot_chat.dart';
import '../screens/shared/agrobot/agrobot_history.dart';

// ── Cliente ────────────────────────────────────────────────────────────────────
import '../screens/cliente/inicioComprador.dart';
import '../models/Consumidor/consumidor_models.dart';
import '../screens/cliente/exploradorProductos.dart';
import '../screens/cliente/buscarProductos.dart';
import '../screens/cliente/detalleProductoCliente.dart';
import '../screens/cliente/perfilProductor.dart';
import '../screens/cliente/productoresCercanos.dart';
import '../screens/cliente/carrito.dart';
import '../screens/cliente/pago.dart';
import '../screens/cliente/resumenConfirmacion.dart';
import '../screens/cliente/pedidoConfirmado.dart';
import '../screens/cliente/misPedidos.dart';
import '../screens/cliente/detallePedidoComprador.dart';
import '../screens/cliente/seguimientoPedido.dart';
import '../screens/cliente/entrega.dart';
import '../screens/cliente/valorarPedido.dart';
import '../screens/cliente/suscripciones.dart';
import '../screens/cliente/category.dart';
import '../screens/cliente/rutaSeguimientoCliente.dart';
import '../screens/cliente/reportarProblema.dart';
import '../screens/cliente/formularioDireccion.dart';

// ── Productor ──────────────────────────────────────────────────────────────────
import '../screens/productor/inicioProductor.dart';
import '../screens/productor/inventario/inventarioProductor.dart';
import '../screens/productor/inventario/agregarProducto.dart';
import '../screens/productor/inventario/detalleProducto.dart';
import '../screens/productor/inventario/registroCosecha.dart';
import '../screens/productor/pedidos/pedidosRecibidos.dart';
import '../screens/productor/pedidos/orderDetailScreen.dart';
import '../screens/productor/pedidos/prepareOrderScreen.dart';
import '../screens/productor/pedidos/sales.dart';
import '../screens/productor/ofertas/crearOferta.dart';
import '../screens/productor/precio_justo/calculadoraPrecioJusto.dart';
import '../screens/productor/precio_justo/resultadoPrecioJusto.dart';
import '../screens/productor/perfilFinca.dart';
import '../screens/productor/editarFinca.dart';
import '../screens/productor/mapaCalorDemanda.dart';
import '../screens/productor/tableroImpacto.dart';

// ── Repartidor ─────────────────────────────────────────────────────────────────
import '../screens/repartidor/homeRepartidor.dart';
import '../screens/repartidor/entregasRepartidor.dart';
import '../screens/repartidor/aceptarEntregaRepartidor.dart';
import '../screens/repartidor/detalleEntregaRepartidor.dart';
import '../screens/repartidor/recogerPedidoRepartidor.dart';
import '../screens/repartidor/entregaEnCursoRepartidor.dart';
import '../screens/repartidor/rutaEntregaRepartidor.dart';
import '../screens/repartidor/confirmarEntregaRepartidor.dart';

import 'app_routes.dart';
import 'productor_router.dart';

/// Router centralizado de AgroTrade.
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final productorRoute = ProductorRouter.generateRoute(settings);
    if (productorRoute != null) return productorRoute;
    final args = settings.arguments;

    switch (settings.name) {
      // ── Onboarding & Auth ────────────────────────────────────────────────
      case AppRoutes.splash:
        return _fade(const Splash());

      case AppRoutes.onboarding:
        return _slide(const OnBoarding());

      case AppRoutes.login:
        return _fade(const Login());

      case AppRoutes.registro:
        final idRol = args is int ? args : null;
        return _slide(Registro(idRol: idRol));

      case AppRoutes.roleSelection:
        return _slide(const Roleselection());

      case AppRoutes.resetPassword:
        return _slide(const RecoverPassword());

      case AppRoutes.verificarCodigo:
        final vcMap = args is Map<String, dynamic> ? args : <String, dynamic>{};
        return _slide(
          VerificarCodigo(correo: vcMap['correo'] as String? ?? ''),
        );

      // ── Shared ────────────────────────────────────────────────────────────
      case AppRoutes.profile:
        return _slide(const Profile());

      case AppRoutes.editarPerfil:
        return _slide(const EditarPerfil());

      case AppRoutes.notificaciones:
        return _slide(const Notificaciones());

      case AppRoutes.centroAyuda:
        return _slide(const CentroAyuda());

      // ── AgroBot ──────────────────────────────────────────────────────────
      case AppRoutes.agrobotWelcome:
        return _slide(const AgrobotWelcome());

      case AppRoutes.agrobotChat:
        return _slide(const AgrobotChat());

      case AppRoutes.agrobotHistory:
        return _slide(const AgrobotHistory());

      case AppRoutes.chat:
        final chatMap = args is Map<String, dynamic>
            ? args
            : <String, dynamic>{};
        return _slide(
          ChatScreen(
            idPedido: chatMap['idPedido'] as int? ?? 0,
            idReceptor: chatMap['idReceptor'] as int? ?? 0,
            nombreReceptor: chatMap['nombreReceptor'] as String? ?? 'Usuario',
            codigoPedido: chatMap['codigoPedido'] as String? ?? '#PED-000',
          ),
        );

      case AppRoutes.inicioComprador:
        return _fade(const InicioComprador());

      case AppRoutes.explorarProductos:
        return _slide(const ExploradorProductos());

      case AppRoutes.buscarProductos:
        return _slide(const BuscarProductos());

      case AppRoutes.detalleProductoCliente:
        if (args is! ProductoMercado) {
          return _slide(
            Scaffold(
              appBar: AppBar(title: const Text('Detalle del producto')),
              body: const Center(
                child: Text(
                  'Selecciona un producto del catálogo para ver su detalle.',
                ),
              ),
            ),
          );
        }
        return _slide(DetalleProductoCliente(producto: args));

      case AppRoutes.perfilProductor:
        return _slide(const PerfilProductorScreen());

      case AppRoutes.productoresCercanos:
        return _slide(const ProductoresCercanos());

      case AppRoutes.carrito:
        return _slide(const CarritoScreen());

      case AppRoutes.pago:
        return _slide(const PagoScreen());

      case AppRoutes.resumenConfirmacion:
        return _slide(const ResumenConfirmacionScreen());

      case AppRoutes.pedidoConfirmado:
        return _fade(const PedidoConfirmadoScreen());

      case AppRoutes.misPedidos:
        return _slide(const MisPedidosScreen());

      case AppRoutes.detallePedidoComprador:
        final dpMap = args is Map<String, dynamic> ? args : <String, dynamic>{};
        return _slide(
          DetallePedidoComprador(
            numeroPedido: dpMap['numeroPedido'] as String? ?? '#0000',
          ),
        );

      case AppRoutes.seguimientoPedido:
        return _slide(const SeguimientoPedidoScreen());

      case AppRoutes.entrega:
        return _slide(const EntregaScreen());

      case AppRoutes.valorarPedido:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(
          ValorarPedidoScreen(
            idPedido: args['idPedido'] as int? ?? 0,
            idProveedor: args['idProveedor'] as int? ?? 1,
          ),
        );

      case AppRoutes.suscripciones:
        return _slide(const SuscripcionesScreen());

      case AppRoutes.categoryScreen:
        return _slide(const CategoryScreen());

      case AppRoutes.rutaSeguimientoCliente:
        return _slide(const RutaSeguimientoClienteScreen());

      case AppRoutes.reportarProblema:
        return _slide(const ReportarProblemaScreen());

      case AppRoutes.formularioDireccion:
        return _slide(const FormularioDireccionScreen());

      // ── Productor ────────────────────────────────────────────────────────────
      case AppRoutes.inicioProductor:
        return _fade(const InicioProductor());

      case AppRoutes.inventario:
        return _slide(const InventarioProductor());

      case AppRoutes.agregarProducto:
        return _slide(const AgregarProducto());

      case AppRoutes.detalleProductoProductor:
        final dpProd = args is Producto
            ? args
            : (args is Map<String, dynamic>
                  ? Producto(
                      id: args['id'] as int? ?? 0,
                      nombre: args['nombre'] as String? ?? 'Producto',
                      cantidad: (args['cantidad'] as num?)?.toDouble() ?? 0.0,
                      unidad: args['unidad'] as String? ?? 'kg',
                      precio: (args['precio'] as num?)?.toDouble() ?? 0.0,
                      estado:
                          args['estado'] as EstadoProducto? ??
                          EstadoProducto.disponible,
                      imagenUrl: args['imagenUrl'] as String? ?? '',
                      descripcion: args['descripcion'] as String?,
                    )
                  : Producto(
                      id: 0,
                      nombre: 'Producto Demo',
                      cantidad: 0.0,
                      unidad: 'kg',
                      precio: 0.0,
                      estado: EstadoProducto.disponible,
                      imagenUrl: '',
                    ));
        return _slide(DetalleProducto(producto: dpProd));

      case AppRoutes.registroCosecha:
        return _slide(const RegistroCosecha());

      case AppRoutes.pedidosRecibidos:
        return _slide(const PedidosRecibidos());

      case AppRoutes.orderDetail:
        return _slide(const OrderDetailsScreen());

      case AppRoutes.prepareOrder:
        return _slide(const PrepareOrderScreen());

      case AppRoutes.ventas:
        return _slide(const Sales());

      case AppRoutes.crearOferta:
        return _slide(const CrearOferta());

      case AppRoutes.calculadoraPrecioJusto:
        return _slide(const CalculadoraPrecioJusto());

      case AppRoutes.resultadoPrecioJusto:
        final rpMap = args is Map<String, dynamic> ? args : <String, dynamic>{};
        return _slide(
          ResultadoPrecioJusto(
            nombreProducto: rpMap['nombreProducto'] as String? ?? 'Producto',
            precioSugerido:
                (rpMap['precioSugerido'] as num?)?.toDouble() ?? 0.0,
            costoTotal: (rpMap['costoTotal'] as num?)?.toDouble() ?? 0.0,
            margenGanancia:
                (rpMap['margenGanancia'] as num?)?.toDouble() ?? 0.0,
            unidad: rpMap['unidad'] as String? ?? 'kg',
            desglose: (rpMap['desglose'] as List<Map<String, dynamic>>?) ?? [],
          ),
        );

      case AppRoutes.perfilFinca:
        return _slide(const PerfilFinca());
      case AppRoutes.editarFinca:
        return _slide(const EditarFincaScreen());

      case AppRoutes.mapaCalorDemanda:
        return _slide(const MapaCalorDemanda());

      case AppRoutes.tableroImpacto:
        return _slide(const TableroImpacto());

      // ── Repartidor ────────────────────────────────────────────────────────
      case AppRoutes.inicioRepartidor:
        return _fade(const InicioRepartidor());

      case AppRoutes.entregasRepartidor:
        return _slide(const Entregasrepartidor());

      case AppRoutes.aceptarEntregaRepartidor:
        return _slide(const AceptarEntregaRepartidor());

      case AppRoutes.detalleEntregaRepartidor:
        final map = args is Map<String, dynamic> ? args : <String, dynamic>{};
        return _slide(
          DetalleEntregaRepartidor(
            pedidoId: map['pedidoId'] as int? ?? 0,
            zonaEntrega: map['zonaEntrega'] as String? ?? '',
            totalPedido: (map['totalPedido'] as num?)?.toDouble() ?? 0.0,
          ),
        );

      case AppRoutes.recogerPedidoRepartidor:
        return _slide(const RecogerPedidoRepartidor());

      case AppRoutes.entregaEnCursoRepartidor:
        return _slide(const EntregaEnCursoRepartidor());

      case AppRoutes.rutaEntregaRepartidor:
        return _slide(const RutaEntregaRepartidor());

      case AppRoutes.confirmarEntregaRepartidor:
        return _slide(const ConfirmarEntregaRepartidor());

      // ── Ruta no encontrada ────────────────────────────────────────────────
      default:
        return _fade(_RouteNotFound(routeName: settings.name ?? '?'));
    }
  }

  // ─── Helpers de transición ────────────────────────────────────────────────

  static PageRouteBuilder<dynamic> _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder<dynamic> _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 280),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }
}

class _RouteNotFound extends StatelessWidget {
  final String routeName;
  const _RouteNotFound({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No existe la ruta "$routeName"',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                ),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
