import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF006E2C);
  static const primarySoft = Color(0xFF00531F);
  static const accentBlue = Color(0xFF15652C0);
  static const TextMain = Color(0xFF263238);
  static const TextSoft = Color(0xFF3D494F);
  static const errorColor = Color(0xFFBA1A1A);
  static const warning = Color(0xFFA35A00);
  static const White = Color(0xFFFFFFFF);
  static const inputBorderColor = Color(0xFF6F7A6D);
  static const inputErrorColor = Color(0xFFB00020);
  static const disabledbtn = Color(0x1A191C1D);
}

class AppTextStyles {
  static const TextStyle Title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.TextMain,
  );
  static const TextStyle SubTitle = TextStyle(
    fontSize: 14,
    color: AppColors.TextSoft,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13,
    color: AppColors.TextMain,
    fontWeight: FontWeight.w600,
  );
}
