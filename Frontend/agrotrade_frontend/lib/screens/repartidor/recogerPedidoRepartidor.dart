import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'entregaEnCursoRepartidor.dart';

class RecogerPedidoRepartidor extends StatelessWidget {
  const RecogerPedidoRepartidor({super.key});

  static const String _producerImage =
      'https://www.figma.com/api/mcp/asset/ca883b8c-523e-4bc0-ad54-149aa66d2ef6.png';

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
          'Recoger pedido',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
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
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_shipping_outlined, color: AppColors.primarySoft, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'En recogida',
                    style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.primarySoft),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _ProgressCard(),
            const SizedBox(height: 24),
            const _ProducerCard(imageUrl: _producerImage),
            const SizedBox(height: 24),
            const _ChecklistCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EntregaEnCursoRepartidor(),
                    ),
                  );
                },
                icon: const Icon(Icons.inventory_2_outlined, size: 20),
                label: const Text(
                  'Confirmar recogida',
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
                onPressed: () => _showSnack(context, 'Faltante reportado'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accentBlue, width: 2),
                  foregroundColor: AppColors.accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Reportar faltante',
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

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Progreso del Pedido',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.titleDark,
            ),
          ),
          SizedBox(height: 16),
          _StepRow(
            active: false,
            completed: true,
            title: 'Entrega aceptada',
          ),
          _StepRow(
            active: true,
            completed: false,
            title: 'Llegada a la finca',
            subtitle: 'Estás en el punto de recogida',
          ),
          _StepRow(
            active: false,
            completed: false,
            title: 'Pedido recibido',
          ),
          _StepRow(
            active: false,
            completed: false,
            title: 'En camino',
          ),
          _StepRow(
            active: false,
            completed: false,
            title: 'Entregado',
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final bool active;
  final bool completed;
  final String title;
  final String? subtitle;

  const _StepRow({
    required this.active,
    required this.completed,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final Color circleColor = completed || active ? AppColors.primarySoft : AppColors.cardBorder;
    final Color textColor = completed || active ? AppColors.primarySoft : AppColors.bodyText;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? AppColors.primaryColor : Colors.white,
                width: active ? 4 : 0,
              ),
            ),
            child: Icon(
              completed ? Icons.check : active ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: completed || active ? Colors.white : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.label.copyWith(fontSize: 14, color: textColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProducerCard extends StatelessWidget {
  final String imageUrl;

  const _ProducerCard({required this.imageUrl});

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
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finca La Esperanza',
                  style: AppTextStyles.label.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.bodyText),
                    const SizedBox(width: 4),
                    Text(
                      'Jinotepe',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primarySoftBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call_outlined, color: AppColors.primarySoft, size: 20),
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verificá el pedido', style: AppTextStyles.label.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            'Revisá que todos los productos estén listos antes de continuar.',
            style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const _ChecklistItem(name: 'Tomate', amount: '2 lb'),
          const SizedBox(height: 10),
          const _ChecklistItem(name: 'Naranja', amount: '2 doc'),
          const SizedBox(height: 10),
          const _ChecklistItem(name: 'Limón', amount: '1 lb'),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String name;
  final String amount;

  const _ChecklistItem({
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x33BECABB)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.chipGrey),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.label.copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text(amount, style: AppTextStyles.SubTitle.copyWith(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
