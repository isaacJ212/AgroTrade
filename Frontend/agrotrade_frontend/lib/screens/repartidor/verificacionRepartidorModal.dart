import 'package:flutter/material.dart';
import '../../models/repartidor_models.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/buttons.dart';
import 'formularioSolicitudRepartidor.dart';
import 'onboardingRepartidor.dart';

/// Modal que muestra el estado de verificación del repartidor
/// No se puede cerrar (barrierDismissible: false) para estados críticos
class VerificacionRepartidorModal extends StatelessWidget {
  final RepartidorEstado estado;
  final VoidCallback? onCorregirReenviar;
  final VoidCallback? onIrAOnboarding;

  const VerificacionRepartidorModal({
    super.key,
    required this.estado,
    this.onCorregirReenviar,
    this.onIrAOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    // Si está verificado, no mostrar nada (el caller decide no mostrar)
    if (estado.estaVerificado) return const SizedBox.shrink();

    return Dialog(
      backgroundColor: AppColors.White,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono de estado
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _iconBgColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_iconData, size: 40, color: _iconColor),
            ),
            const SizedBox(height: 20),
            
            // Título
            Text(
              _title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            
            // Mensaje principal
            Text(
              _message,
              textAlign: TextAlign.center,
              style: AppTextStyles.SubTitle.copyWith(fontSize: 15, height: 1.5),
            ),
            
            // Comentario del moderador (si existe y es rechazada)
            if (estado.estaRechazada && estado.comentarioModerador != null && estado.comentarioModerador!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputErrorColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comentario del moderador:',
                      style: AppTextStyles.label.copyWith(fontSize: 13, color: AppColors.inputErrorColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      estado.comentarioModerador!,
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14, color: AppColors.bodyText),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Botones de acción
            if (estado.estaPendiente) ...[
              // Solo botón de cerrar (el usuario debe esperar)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    foregroundColor: AppColors.primaryColor,
                  ),
                  child: const Text('Entendido', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ] else if (estado.estaRechazada) ...[
              // Botón: Corregir y reenviar
              PrimaryButton(
                label: 'Corregir y reenviar',
                icon: Icons.edit_outlined,
                radius: 24,
                onPressed: () {
                  Navigator.pop(context);
                  onCorregirReenviar?.call();
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar', style: TextStyle(color: AppColors.TextSoft)),
              ),
            ] else if (estado.requiereOnboarding) ...[
              // Botón: Ir a Onboarding
              PrimaryButton(
                label: 'Completar mi perfil',
                icon: Icons.assignment_outlined,
                radius: 24,
                onPressed: () {
                  Navigator.pop(context);
                  onIrAOnboarding?.call();
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Más tarde', style: TextStyle(color: AppColors.TextSoft)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _iconBgColor {
    if (estado.estaPendiente) return AppColors.amber;
    if (estado.estaRechazada) return AppColors.errorColor;
    return AppColors.primaryColor;
  }

  Color get _iconColor {
    if (estado.estaPendiente) return AppColors.amber;
    if (estado.estaRechazada) return AppColors.errorColor;
    return AppColors.primaryColor;
  }

  IconData get _iconData {
    if (estado.estaPendiente) return Icons.hourglass_top_outlined;
    if (estado.estaRechazada) return Icons.cancel_outlined;
    return Icons.assignment_outlined;
  }

  String get _title {
    if (estado.estaPendiente) return 'Solicitud en Revisión';
    if (estado.estaRechazada) return 'Solicitud Rechazada';
    return 'Perfil Incompleto';
  }

  String get _message {
    if (estado.estaPendiente) {
      return 'Tu solicitud está siendo revisada por nuestros moderadores. Te notificaremos por correo electrónico cuando haya una respuesta.';
    }
    if (estado.estaRechazada) {
      return 'Tu solicitud no fue aprobada. Puedes corregir la información y volver a enviarla.';
    }
    return 'Para ser repartidor necesitas completar tu perfil y enviar la solicitud de verificación.';
  }

  /// Helper para mostrar el modal con barrera no dismissible para estados críticos
  static Future<void> show({
    required BuildContext context,
    required RepartidorEstado estado,
    VoidCallback? onCorregirReenviar,
    VoidCallback? onIrAOnboarding,
  }) {
    final barrierDismissible = !estado.estaPendiente && !estado.estaRechazada;
    
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => VerificacionRepartidorModal(
        estado: estado,
        onCorregirReenviar: onCorregirReenviar,
        onIrAOnboarding: onIrAOnboarding,
      ),
    );
  }
}