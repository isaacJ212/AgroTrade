import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/app_text_field.dart';
import 'repartidor_widgets.dart';

class AvatarPerfilRepartidor extends StatelessWidget {
  final IconData icono;

  const AvatarPerfilRepartidor({super.key, required this.icono});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primarySoftBg,
          border: Border.all(color: AppColors.cardBorder, width: 2),
        ),
        child: Icon(icono, size: 56, color: AppColors.primaryColor),
      ),
    );
  }
}

class CampoPerfilRepartidor extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const CampoPerfilRepartidor({
    super.key,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: appInputDecoration(label: etiqueta),
      child: SelectableText(
        valor,
        style: RepartidorTextStyles.menu,
      ),
    );
  }
}
