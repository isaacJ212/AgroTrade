import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../cliente/suscripciones.dart';

class SuscripcionConfirmadaScreen extends StatelessWidget {
  final Map<String, dynamic> plan;
  const SuscripcionConfirmadaScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final double precio = plan['precio'] ?? 0.0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            children: [
              const Spacer(),

              _buildIconoExito(),
              const SizedBox(height: 28),

              const Text(
                '¡Suscripción exitosa!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Te has suscrito correctamente al plan.\nHemos enviado un recibo a tu correo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.TextSoft,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 32),

              _buildResumenCard(plan['nombre'], precio),
              const SizedBox(height: 16),
              _buildAviso(),

              const Spacer(),

              PrimaryButton(
                label: 'Mis suscripciones',
                radius: 100,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const SuscripcionesScreen(),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconoExito() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySoftBg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 48,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildResumenCard(String nombrePlan, double precio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _FilaInfo(label: 'Plan', valor: nombrePlan),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          _FilaInfo(
            label: 'Total pagado',
            valor: 'C\$${precio.toStringAsFixed(2)}',
            valorColor: AppColors.primaryColor,
            valorBold: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          Row(
            children: [
              const Text(
                'Estado',
                style: TextStyle(fontSize: 14, color: AppColors.TextSoft),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Activo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAviso() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.mail_outline_rounded, size: 16, color: AppColors.TextSoft),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hemos enviado un correo electrónico con los detalles de tu suscripción y el recibo de pago.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.TextSoft,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaInfo extends StatelessWidget {
  final String label;
  final String valor;
  final Color? valorColor;
  final bool valorBold;

  const _FilaInfo({
    required this.label,
    required this.valor,
    this.valorColor,
    this.valorBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.TextSoft),
        ),
        const Spacer(),
        Text(
          valor,
          style: TextStyle(
            fontSize: 14,
            fontWeight: valorBold ? FontWeight.w700 : FontWeight.w500,
            color: valorColor ?? AppColors.titleDark,
          ),
        ),
      ],
    );
  }
}
