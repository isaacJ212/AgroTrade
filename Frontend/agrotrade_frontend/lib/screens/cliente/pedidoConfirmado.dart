import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'inicioComprador.dart';
import 'seguimientoPedido.dart';

class PedidoConfirmadoScreen extends StatelessWidget {
  const PedidoConfirmadoScreen({super.key});

  static const String _numeroPedido = 'AT-2051';
  static const double _total = 146.00;

  @override
  Widget build(BuildContext context) {
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
                '¡Pedido confirmado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Tu pedido fue enviado correctamente\na los productores.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.TextSoft,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 32),

              _buildResumenCard(),
              const SizedBox(height: 16),
              _buildAviso(),

              const Spacer(),

              PrimaryButton(
                label: 'Ver seguimiento',
                radius: 100,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SeguimientoPedidoScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const InicioComprador(),
                      ),
                      (_) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    'Seguir comprando',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
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

  Widget _buildResumenCard() {
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
          _FilaInfo(label: 'Pedido #', valor: _numeroPedido),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          _FilaInfo(
            label: 'Total',
            valor: 'C\$${_total.toStringAsFixed(2)}',
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
                      'Confirmado',
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
          Icon(Icons.info_outline_rounded, size: 16, color: AppColors.TextSoft),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Te avisaremos cuando los productores comiencen a preparar tu pedido.',
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
