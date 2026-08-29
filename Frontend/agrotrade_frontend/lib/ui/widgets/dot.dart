import 'package:flutter/material.dart';
import '../app_theme.dart';

class Dot extends StatelessWidget {
  final bool activo;

  const Dot({super.key, this.activo = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activo ? AppColors.primaryColor : AppColors.inputBorderColor,
      ),
    );
  }
}
