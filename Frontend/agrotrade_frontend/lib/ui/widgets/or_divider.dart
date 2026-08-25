import 'package:flutter/material.dart';
import '../app_theme.dart';

class OrDivider extends StatelessWidget {
  final String text;
  const OrDivider({super.key, this.text = "o"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.inputBorderColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: AppTextStyles.SubTitle),
        ),
        const Expanded(child: Divider(color: AppColors.inputBorderColor)),
      ],
    );
  }
}
