import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF006E2C);
  static const primarySoft = Color(0xFF00531F);
  static const accentBlue = Color(0xFF1565C0);
  static const TextMain = Color(0xFF263238);
  static const TextSoft = Color(0xFF3D494F);
  static const errorColor = Color(0xFFBA1A1A);
  static const warning = Color(0xFFA35A00);
  static const White = Color(0xFFFFFFFF);
  static const inputBorderColor = Color(0xFF6F7A6D);
  static const inputErrorColor = Color(0xFFB00020);
  static const disabledbtn = Color(0x1A191C1D);
  static const primarySoftBg = Color(0xFFE9F5EC);
  static const primaryGlow = Color(0x40006E2C);

  // colores para la pantalla del productor
  static const scaffoldBg = Color(0xFFF8F9FA);
  static const cardBorder = Color(0xFFE1E3E4);
  static const tileBg = Color(0xFFEDEEEF);
  static const titleDark = Color(0xFF191C1D);
  static const bodyText = Color(0xFF3F493E);
  static const amber = Color(0xFFF9A825);
  static const errorDark = Color(0xFF93000A);
  static const errorBg = Color(0xFFFFDAD6);
  static const navPill = Color(0xFFE6F4EA);
  static const fabIcon = Color(0xFF91EE9C);
  static const chipGrey = Color(0xFFBECABB);

  static const screenBg = Color(0xFFF1F3F1);
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

  // esto es solo para pesos de pubpec
  static const TextStyle headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.titleDark,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.titleDark,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 28,
    color: AppColors.bodyText,
  );

  static const TextStyle startValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle chip = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle statValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );
}
