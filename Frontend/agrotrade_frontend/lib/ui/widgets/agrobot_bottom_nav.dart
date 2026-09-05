import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../routes/app_routes.dart';
import 'productor_bottom_nav.dart';

/// BottomNav para las pantallas de AgroBot.
/// Retiene los botones correspondientes a cada rol de usuario y su navegación.
class AgrobotBottomNav extends StatelessWidget {
  const AgrobotBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = ApiSession.instance.roles;

    if (roles.contains('Productor/Proveedor') || roles.contains('Productor')) {
      return ProductorBottomNav(
        items: const [
          NavElemento(
            label: 'Inicio',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          NavElemento(
            label: 'Explorar',
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore,
          ),
          NavElemento(
            label: 'Pedidos',
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            badge: true,
          ),
          NavElemento(
            label: 'Perfil',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
        currentIndex: -1, // Ninguno seleccionado porque estamos en AgroBot
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
          if (index == 1) Navigator.pushReplacementNamed(context, AppRoutes.inventario);
          if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.pedidosRecibidos);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.perfilFinca);
        },
      );
    } else if (roles.contains('Repartidor')) {
      return ProductorBottomNav(
        items: const [
          NavElemento(
            label: 'Inicio',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          NavElemento(
            label: 'Entregas',
            icon: Icons.local_shipping_outlined,
            activeIcon: Icons.local_shipping,
          ),
          NavElemento(
            label: 'Ruta',
            icon: Icons.route_outlined,
            activeIcon: Icons.route,
          ),
          NavElemento(
            label: 'Perfil',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
        currentIndex: -1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
          if (index == 1) Navigator.pushReplacementNamed(context, AppRoutes.entregasRepartidor);
          if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.rutaEntregaRepartidor);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.profile);
        },
      );
    } else {
      // Por defecto Cliente/Comprador
      return ProductorBottomNav(
        items: const [
          NavElemento(
            label: 'Inicio',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          NavElemento(
            label: 'Explorar',
            icon: Icons.search_outlined,
            activeIcon: Icons.search,
          ),
          NavElemento(
            label: 'Pedidos',
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
          ),
          NavElemento(
            label: 'Perfil',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
        currentIndex: -1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
          if (index == 1) Navigator.pushReplacementNamed(context, AppRoutes.explorarProductos);
          if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.misPedidos);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.profile);
        },
      );
    }
  }
}
