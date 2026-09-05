import 'package:flutter/material.dart';
import '../models/productor_models.dart';
import '../services/productor_store.dart';
import '../ui/widgets/productor_widgets.dart';
import '../screens/productor/productorShell.dart';
import '../screens/productor/inventario/agregarProducto.dart';
import '../screens/productor/inventario/detalleProducto.dart';
import '../screens/productor/inventario/registroCosecha.dart';
import '../screens/productor/pedidos/orderDetailScreen.dart';
import '../screens/productor/pedidos/prepareOrderScreen.dart';
import '../screens/productor/pedidos/sales.dart';
import '../screens/productor/precio_justo/calculadoraPrecioJusto.dart';
import '../screens/productor/precio_justo/resultadoPrecioJusto.dart';
import '../screens/productor/ofertas/crearOferta.dart';
import '../screens/productor/editarFinca.dart';
import '../screens/productor/mapaCalorDemanda.dart';
import '../screens/productor/tableroImpacto.dart';
import '../screens/productor/perfilPublicoProductor.dart';
import '../screens/productor/datosPersonalesProductor.dart';
import '../screens/productor/configuracionProductor.dart';
import '../screens/productor/contrasenaProductor.dart';
import '../screens/productor/ayudaProductor.dart';
import '../screens/productor/notificacionesProductor.dart';
import '../screens/shared/chat/chatMensajes.dart';
import 'app_routes.dart';

class ProductorRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (!(settings.name?.startsWith('/productor/') ?? false)) return null;
    final args = settings.arguments;
    final store = ProductorStore.instance;
    final Producto? producto = args is Producto
        ? store.producto(args.id) ?? args
        : args is int
        ? store.producto(args)
        : args is Map && args['id'] is int
        ? store.producto(args['id'] as int)
        : null;
    final String? pedidoId = args is PedidoRecibido
        ? args.codigo
        : args is String
        ? args
        : args is Map && args['codigo'] is String
        ? args['codigo'] as String
        : null;
    Widget page;
    switch (settings.name) {
      case AppRoutes.inicioProductor:
        page = const ProductorShell();
        break;
      case AppRoutes.inventario:
        page = const ProductorShell(initialIndex: 1);
        break;
      case AppRoutes.pedidosRecibidos:
        page = const ProductorShell(initialIndex: 2);
        break;
      case AppRoutes.perfilFinca:
        page = const ProductorShell(initialIndex: 3);
        break;
      case AppRoutes.agregarProducto:
        page = AgregarProducto(producto: producto);
        break;
      case AppRoutes.detalleProductoProductor:
        page = producto == null
            ? const ProductorPage(
                title: 'Detalle del producto',
                children: [
                  ProductorEmpty('Selecciona un producto del inventario.'),
                ],
              )
            : DetalleProducto(producto: producto);
        break;
      case AppRoutes.registroCosecha:
        page = RegistroCosecha(producto: producto);
        break;
      case AppRoutes.orderDetail:
        page = OrderDetailsScreen(pedidoId: pedidoId);
        break;
      case AppRoutes.prepareOrder:
        page = PrepareOrderScreen(pedidoId: pedidoId);
        break;
      case AppRoutes.ventas:
        page = const Sales();
        break;
      case AppRoutes.crearOferta:
        page = CrearOferta(producto: producto);
        break;
      case AppRoutes.calculadoraPrecioJusto:
        page = CalculadoraPrecioJusto(
          nombreProducto: producto?.nombre,
          unidadInicial: producto?.unidad ?? 'kg',
        );
        break;
      case AppRoutes.resultadoPrecioJusto:
        final map = args is Map ? args : const {};
        page = ResultadoPrecioJusto(
          nombreProducto: map['nombreProducto'] as String? ?? 'Producto',
          precioSugerido: (map['precioSugerido'] as num?)?.toDouble() ?? 0,
          costoTotal: (map['costoTotal'] as num?)?.toDouble() ?? 0,
          margenGanancia: (map['margenGanancia'] as num?)?.toDouble() ?? 0,
          unidad: map['unidad'] as String? ?? 'kg',
          desglose: const [],
          permitirAplicar: false,
        );
        break;
      case AppRoutes.editarFinca:
        page = const EditarFincaScreen();
        break;
      case AppRoutes.mapaCalorDemanda:
        page = const MapaCalorDemanda();
        break;
      case AppRoutes.tableroImpacto:
        page = const TableroImpacto();
        break;
      case '/productor/perfil-publico':
        page = const PerfilPublicoProductor();
        break;
      case '/productor/datos-personales':
        page = const DatosPersonalesProductor();
        break;
      case '/productor/configuracion':
        page = const ConfiguracionProductor();
        break;
      case '/productor/contrasena':
        page = const ContrasenaProductor();
        break;
      case '/productor/ayuda':
        page = const AyudaProductor();
        break;
      case '/productor/notificaciones':
        page = const NotificacionesProductor();
        break;
      case '/productor/chat':
        final chat = args is Map ? args : const {};
        final nombre = chat['contactName'] as String? ?? 'Comprador';
        page = ChatMensajes(
          contactName: nombre,
          contactRole: 'Comprador',
          producerMode: true,
          initialMessages: store.mensajes(nombre),
          onMessagesChanged: (mensajes) =>
              store.guardarMensajes(nombre, mensajes),
        );
        break;
      default:
        return null;
    }
    return MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);
  }
}
