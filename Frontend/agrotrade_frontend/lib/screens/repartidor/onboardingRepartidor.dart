import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/buttons.dart';
import 'formularioSolicitudRepartidor.dart';

class OnboardingRepartidor extends StatelessWidget {
  const OnboardingRepartidor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ilustración
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primarySoftBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.3), width: 2),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 100,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              
              // Título
              Text(
                'Bienvenido a nuestro equipo de repartidores',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 16),
              
              // Subtítulo
              Text(
                'Para garantizar la calidad del servicio, debes pasar una verificación por parte de nuestros moderadores. Completa tu perfil y envía tu solicitud para comenzar.',
                textAlign: TextAlign.center,
                style: AppTextStyles.SubTitle.copyWith(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 40),
              
              // Botón principal
              PrimaryButton(
                label: 'Enviar Solicitud',
                icon: Icons.send_outlined,
                radius: 24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FormularioSolicitudRepartidor()),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Texto informativo
              Text(
                'Necesitarás: cédula, fotos de documentos,\nlicencia, foto de perfil y cuenta bancaria.',
                textAlign: TextAlign.center,
                style: AppTextStyles.SubTitle.copyWith(fontSize: 12, color: AppColors.TextSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}