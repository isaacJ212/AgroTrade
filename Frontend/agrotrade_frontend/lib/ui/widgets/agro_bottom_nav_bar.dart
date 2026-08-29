import 'package:flutter/material.dart';
import '../app_theme.dart';

class AgroBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AgroBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavBarItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: 'Inicio',
      ),
      _NavBarItem(
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: 'Explorar',
      ),
      _NavBarItem(
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart_rounded,
        label: 'Ventas',
      ),
      _NavBarItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Perfil',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE4E7E5), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final bool selected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 72,
                        height: 38,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE3F3E8)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          selected ? item.selectedIcon : item.icon,
                          size: 24,
                          color: selected
                              ? AppColors.primaryColor
                              : const Color(0xFF4E5A53),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: selected
                              ? AppColors.primaryColor
                              : const Color(0xFF58615C),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
