import 'package:flutter/material.dart';


/// Botón flotante de AgroBot.
/// Muestra la imagen del personaje AgroBot sobre un fondo verde redondeado.
class SupportFab extends StatelessWidget {
  final VoidCallback onPressed;

  /// Parámetro opcional para mantener compatibilidad con usos anteriores.
  // ignore: unused_element
  final IconData? icono;
  final Color? colorIcono;

  const SupportFab({
    super.key,
    required this.onPressed,
    this.icono,
    this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 65,
        height: 65,
        child: Image.asset(
          'lib/assets/images/Agrobot/assets_preview_rev_1.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

