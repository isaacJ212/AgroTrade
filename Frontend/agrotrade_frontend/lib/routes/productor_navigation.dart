import 'package:flutter/material.dart';
import '../services/api_session.dart';
import '../services/productor_store.dart';
import 'app_routes.dart';

class ProductorNavigation extends InheritedWidget {
  final ValueChanged<int> onTab;
  const ProductorNavigation({
    super.key,
    required this.onTab,
    required super.child,
  });
  static void cambiarTab(BuildContext context, int index) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ProductorNavigation>();
    if (scope != null) {
      scope.onTab(index);
      return;
    }
    const routes = [
      AppRoutes.inicioProductor,
      AppRoutes.inventario,
      AppRoutes.pedidosRecibidos,
      AppRoutes.perfilFinca,
    ];
    if (index >= 0 && index < routes.length)
      Navigator.pushReplacementNamed(context, routes[index]);
  }

  static void cerrarSesion(BuildContext context) {
    ApiSession.instance.clear();
    ProductorStore.instance.reiniciar();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  static void chat(BuildContext context, String cliente) => Navigator.pushNamed(
    context,
    '/productor/chat',
    arguments: {'contactName': cliente, 'contactRole': 'Comprador'},
  );
  @override
  bool updateShouldNotify(ProductorNavigation oldWidget) => false;
}
