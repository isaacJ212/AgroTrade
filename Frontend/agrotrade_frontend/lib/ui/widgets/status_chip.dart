import 'package:flutter/material.dart';
import '../app_theme.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color color;
  final IconData? icon;
  final Color? iconColor;
  final double radius;

  const StatusChip({
    super.key,
    required this.label,
    required this.background,
    required this.color,
    this.icon,
    this.iconColor,
    this.radius = 10,
  });



   @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, 
            color: iconColor ?? color),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTextStyles.chip.copyWith(color: color)),
        ],
      ),
    );
  }
}

  
class ChipEstado extends StatelessWidget {
  final String texto;
  final Color color;

  const ChipEstado({super.key, required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
