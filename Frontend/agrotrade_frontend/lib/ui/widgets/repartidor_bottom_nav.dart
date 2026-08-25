import 'package:flutter/material.dart';
import '../app_theme.dart';

class RepartidorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RepartidorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          _item(0, Icons.home_outlined, Icons.home, 'Inicio'),
          _item(1, Icons.local_shipping_outlined, Icons.local_shipping, 'Entregas'),
          _item(2, Icons.route_outlined, Icons.route, 'Ruta'),
          _item(3, Icons.person_outline, Icons.person, 'Perfil'),
        ],
      ),
    );
  }

  Widget _item(
    int index,
    IconData icon,
    IconData activeIcon,
    String label, {
    bool badge = false,
  }) {
    final bool activo = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Container(
              width: 68,
              height: 32,
              decoration: BoxDecoration(
                color: activo ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      activo ? activeIcon : icon,
                      color: activo ? AppColors.fabIcon : AppColors.bodyText,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                color: activo ? AppColors.primaryColor : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
