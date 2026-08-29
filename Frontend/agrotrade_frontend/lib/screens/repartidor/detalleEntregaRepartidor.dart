import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'aceptarEntregaRepartidor.dart';

class DetalleEntregaRepartidor extends StatelessWidget {
  final int? pedidoId;
  final String? zonaEntrega;
  final double? totalPedido;

  const DetalleEntregaRepartidor({
    super.key,
    this.pedidoId,
    this.zonaEntrega,
    this.totalPedido,
  });

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
          'Detalle de la entrega',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSnack(context, 'Notificaciones'),
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.bodyText,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          children: [
            _SummaryHeader(
              title: 'ENTREGA',
              subtitle: pedidoId == null ? '#AT-2051' : '#AT-$pedidoId',
              status: 'Estado: Pendiente',
              statusIcon: Icons.schedule,
            ),
            const SizedBox(height: 16),
            _RouteSection(
              accent: AppColors.primaryColor,
              iconBackground: AppColors.primarySoftBg,
              title: 'Recogida',
              titleColor: AppColors.primaryColor,
              icon: Icons.storefront_outlined,
              name: 'Finca La Esperanza',
              place: 'Jinotepe, Carazo',
              extra: 'Hora: 10:30 a. m.',
              actionLabel: 'Ver ubicación',
              actionColor: AppColors.accentBlue,
              instruction: null,
            ),
            const SizedBox(height: 16),
            _RouteSection(
              accent: AppColors.accentBlue,
              iconBackground: const Color(0xFFD6E3FF),
              title: 'Destino',
              titleColor: AppColors.accentBlue,
              icon: Icons.person_pin_circle_outlined,
              name: 'María López',
              place: zonaEntrega == null ? 'Jinotepe, Carazo' : zonaEntrega!,
              instruction: '"Casa de portón verde, frente al parque."',
              actionLabel: 'Ver ubicación',
              actionColor: AppColors.accentBlue,
              extra: null,
              showInstruction: true,
            ),
            const SizedBox(height: 16),
            _OrderSection(
              title: pedidoId == null ? 'Pedido #AT-2051' : 'Pedido #AT-$pedidoId',
              productsLabel: totalPedido == null
                  ? '3 productos'
                  : '\$${totalPedido!.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AceptarEntregaRepartidor(
                        pedidoId: pedidoId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Aceptar entrega',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => _showSnack(context, 'Mensaje enviado'),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text(
                  'Enviar mensaje',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentBlue,
                  side: const BorderSide(color: AppColors.accentBlue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _showSnack(context, 'Problema reportado'),
              icon: const Icon(
                Icons.report_problem_outlined,
                color: AppColors.inputErrorColor,
              ),
              label: const Text(
                'Reportar problema',
                style: TextStyle(
                  color: AppColors.inputErrorColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData statusIcon;

  const _SummaryHeader({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusIcon,
  });

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
      child: Row(
        children: [
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
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 24,
                    color: AppColors.titleDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cardBorder,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 14, color: AppColors.bodyText),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: AppTextStyles.chip.copyWith(color: AppColors.bodyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteSection extends StatelessWidget {
  final Color accent;
  final Color iconBackground;
  final String title;
  final Color titleColor;
  final IconData icon;
  final String name;
  final String place;
  final String? extra;
  final String actionLabel;
  final Color actionColor;
  final String? instruction;
  final bool showInstruction;

  const _RouteSection({
    required this.accent,
    required this.iconBackground,
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.name,
    required this.place,
    required this.actionLabel,
    required this.actionColor,
    this.extra,
    this.instruction,
    this.showInstruction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: titleColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 14,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 16,
                        color: AppColors.titleDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place,
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                    ),
                    if (extra != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        extra!,
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (showInstruction && instruction != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tileBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                instruction!,
                style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.place, size: 16, color: actionColor),
              label: Text(
                actionLabel,
                style: TextStyle(
                  color: actionColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSection extends StatelessWidget {
  final String title;
  final String productsLabel;

  const _OrderSection({required this.title, required this.productsLabel});

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
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 18,
                color: AppColors.bodyText,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.label.copyWith(fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  productsLabel,
                  style: AppTextStyles.chip.copyWith(color: AppColors.bodyText),
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.cardBorder),
          const _ProductRow(
            imageUrl:
                'https://www.figma.com/api/mcp/asset/9f6738cc-b9c2-4767-b1d0-de53367feef0.png',
            name: 'Tomate',
            amount: '2 lb',
          ),
          const SizedBox(height: 12),
          const _ProductRow(
            imageUrl:
                'https://www.figma.com/api/mcp/asset/f6351e1d-8669-4114-b4dd-64deb847dd99.png',
            name: 'Naranja',
            amount: '2 doc',
          ),
          const SizedBox(height: 12),
          const _ProductRow(
            imageUrl:
                'https://www.figma.com/api/mcp/asset/fc84d92f-272c-44a6-a913-fbe64d8c0f70.png',
            name: 'Limón',
            amount: '1 lb',
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String amount;

  const _ProductRow({
    required this.imageUrl,
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: AppTextStyles.label.copyWith(fontSize: 16)),
            const SizedBox(height: 2),
            Text(amount, style: AppTextStyles.SubTitle.copyWith(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
