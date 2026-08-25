import 'package:flutter/material.dart';
import '../app_theme.dart';

class SupportFab extends StatelessWidget {
  final IconData icono;
  final Color colorIcono;
  final VoidCallback onPressed;

  const SupportFab({
    super.key,
    required this.icono,
    required this.onPressed,
    this.colorIcono = AppColors.fabIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(
            Icons.smart_toy_outlined,
            color: AppColors.fabIcon,
            size: 28,
          ),
        ),
      ),
    );
  }
}
