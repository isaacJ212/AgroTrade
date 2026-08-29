import 'package:flutter/material.dart';
import '../app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final double radius;
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.radius ,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.White, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: AppColors.White,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color = AppColors.accentBlue,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? AppColors.TextMain;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          backgroundColor: AppColors.White,
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class TertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const TertiaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.errorColor,
          backgroundColor: AppColors.White,
          side: const BorderSide(color: AppColors.errorColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class NeutralButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color textColor;

  const NeutralButton({
    super.key,
    required this.label,
    this.onPressed,
    this.background = AppColors.tileBg,
    this.textColor = AppColors.titleDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
