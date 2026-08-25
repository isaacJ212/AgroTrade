import 'package:flutter/material.dart';
import '../app_theme.dart';

class NavElemento {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool badge;

  const NavElemento({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badge = false,
  });
}

class ProductorBottomNav extends StatelessWidget {
  final List<NavElemento> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ProductorBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.White,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        children: List.generate(items.length, (index) {
          return _item(index, items[index]);
        }),
      ),
    );
  }

  Widget _item(int index, NavElemento elemento) {
    final bool activo = index == currentIndex;
    final IconData icono = activo
        ? (elemento.activeIcon ?? elemento.icon)
        : elemento.icon;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: activo ? AppColors.navPill : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      icono,
                      color: activo
                          ? AppColors.primarySoft
                          : AppColors.bodyText,
                      size: 22,
                    ),
                  ),
                  if (elemento.badge)
                    Positioned(
                      top: 5,
                      right: 17,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.inputErrorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              elemento.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                color: activo ? AppColors.titleDark : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
