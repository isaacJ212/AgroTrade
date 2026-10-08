import 'package:flutter/material.dart';
import '../../services/delivery_api_service.dart';
import '../../ui/app_theme.dart';
import 'entregaEnCursoRepartidor.dart';

class RecogerPedidoRepartidor extends StatefulWidget {
  final int? pedidoId;
  const RecogerPedidoRepartidor({super.key, this.pedidoId});

  @override
  State<RecogerPedidoRepartidor> createState() => _RecogerPedidoRepartidorState();
}

class _RecogerPedidoRepartidorState extends State<RecogerPedidoRepartidor> {
  bool _confirmando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('Recoger pedido #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pedido #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.storefront_outlined, label: 'Punto de recogida', value: 'Por confirmar'),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.schedule_outlined, label: 'Hora prevista', value: '—'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x4D006E2C)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recogida de pedido', style: AppTextStyles.productoTitle),
                  const SizedBox(height: 8),
                  const Text(
                    'El detalle de productos se cargará cuando el backend exponga el endpoint de detalle de entrega.',
                    style: AppTextStyles.SubTitle,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Confirma la recogida para continuar con la entrega.',
                    style: AppTextStyles.SubTitle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirmando ? null : _confirmarRecogida,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _confirmando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Confirmar recogida', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Al confirmar, el pedido pasará a "En curso" y podrás seguir la ruta.',
              textAlign: TextAlign.center,
              style: AppTextStyles.SubTitle,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarRecogida() async {
    if (widget.pedidoId == null) return;
    setState(() => _confirmando = true);
    try {
      await DeliveryApiService.instance.acceptDelivery(widget.pedidoId!);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EntregaEnCursoRepartidor(pedidoId: widget.pedidoId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorColor),
      );
    } finally {
      if (mounted) setState(() => _confirmando = false);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.SubTitle.copyWith(fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.label.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}