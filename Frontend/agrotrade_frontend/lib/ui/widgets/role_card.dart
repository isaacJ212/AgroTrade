import 'package:flutter/material.dart';
import '../app_theme.dart';

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: true,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          onTap();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? AppColors.primarySoftBg : AppColors.White,
            border: Border.all(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.inputBorderColor.withOpacity(0.4),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primarySoftBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22),
              ),
              const SizedBox(height: 10),
              Text(title, style: AppTextStyles.Title.copyWith(fontSize: 16)),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.SubTitle),
            ],
          ),
        ),
      ),
    );
  }
}
