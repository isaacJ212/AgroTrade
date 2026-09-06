import 'package:flutter/material.dart';
import 'productor_bottom_nav.dart';

class RepartidorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RepartidorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<NavElemento> _items = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return ProductorBottomNav(
      items: _items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
