import 'package:flutter/material.dart';
import '../app_theme.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.titleDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.cardTitle),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.label.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
