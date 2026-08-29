import 'package:flutter/material.dart';
import '../app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final Color? iconColor;
  final Color titleColor;
  final Color background;
  final Color border;
  final bool glow;
  final Widget? footer;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.accent = AppColors.primaryColor,
    this.iconColor,
    this.titleColor = AppColors.bodyText,
    this.background = AppColors.White,
    this.border = AppColors.cardBorder,
    this.glow = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Stack(
        children: [
          if (glow)
            Positioned(
              top: 4,
              right: -16,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.fabIcon.withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: Icon(icon, color: iconColor ?? accent, size: 26),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(color: titleColor),
                ),
                const SizedBox(height: 14),
                Text(
                  value,
                  style: AppTextStyles.statValue.copyWith(color: accent),
                ),
                if (footer != null) ...[const SizedBox(height: 14), footer!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
