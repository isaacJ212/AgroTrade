import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import 'recogerPedidoRepartidor.dart';

class AceptarEntregaRepartidor extends StatelessWidget {
  final int? pedidoId;

  const AceptarEntregaRepartidor({super.key, this.pedidoId});

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceAlt,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
        title: const Text(
          'Entregas',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSnack(context, 'Notificaciones'),
            icon: const Icon(Icons.notifications_outlined, color: AppColors.bodyText),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'Aceptar entrega',
              textAlign: TextAlign.center,
              style: AppTextStyles.headline.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 6),
            Text(
              'Confirmá que podés realizar esta entrega.',
              textAlign: TextAlign.center,
              style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 24),
            const _SummaryCard(),
            const SizedBox(height: 24),
            _NoticeCard(
              text: 'Al aceptar, esta entrega quedará asignada a tu ruta.',
              icon: Icons.info_outline,
              background: const Color(0xFFEEEEEF),
              iconColor: AppColors.primarySoft,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final id = pedidoId;
                  if (id == null) {
                    _showSnack(context, 'No hay un pedido asociado a esta entrega');
                    return;
                  }

                  try {
                    await DeliveryApiService.instance.acceptDelivery(id);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecogerPedidoRepartidor(),
                      ),
                    );
                  } on ApiException catch (e) {
                    if (!context.mounted) return;
                    _showSnack(context, e.message);
                  }
                },
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text(
                  'Aceptar entrega',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accentBlue, width: 2),
                  foregroundColor: AppColors.accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Volver',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _PickupRow(
            iconBackground: AppColors.primarySoftBg,
            icon: Icons.storefront_outlined,
            title: 'RECOGIDA',
            name: 'Finca La Esperanza',
            detail: 'Hora de recogida: 10:30 a. m.',
            iconColor: AppColors.primarySoft,
          ),
          const SizedBox(height: 24),
          _PickupRow(
            iconBackground: const Color(0xFFD6E3FF),
            icon: Icons.person_pin_circle_outlined,
            title: 'DESTINO',
            name: 'Jinotepe',
            detail: 'Ruta disponible al iniciar',
            iconColor: AppColors.accentBlue,
          ),
        ],
      ),
    );
  }
}

class _PickupRow extends StatelessWidget {
  final Color iconBackground;
  final IconData icon;
  final String title;
  final String name;
  final String detail;
  final Color iconColor;

  const _PickupRow({
    required this.iconBackground,
    required this.icon,
    required this.title,
    required this.name,
    required this.detail,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.SubTitle.copyWith(
                  fontSize: 12,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: AppTextStyles.label.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(detail, style: AppTextStyles.SubTitle.copyWith(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color background;
  final Color iconColor;

  const _NoticeCard({
    required this.text,
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
