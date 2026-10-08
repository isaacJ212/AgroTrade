import 'package:flutter/material.dart';
import '../../services/delivery_api_service.dart';
import '../../ui/app_theme.dart';
import 'recogerPedidoRepartidor.dart';

class AceptarEntregaRepartidor extends StatefulWidget {
  final int? pedidoId;
  const AceptarEntregaRepartidor({super.key, this.pedidoId});

  @override
  State<AceptarEntregaRepartidor> createState() => _AceptarEntregaRepartidorState();
}

class _AceptarEntregaRepartidorState extends State<AceptarEntregaRepartidor> {
  bool _confirmado = false;
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('Aceptar entrega #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                Text('Entrega #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                _InfoRow(icon: Icons.storefront_outlined, label: 'Punto de recogida', value: 'Por confirmar'),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.location_on_outlined, label: 'Entregar en', value: '—'),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.schedule_outlined, label: 'Hora de recogida', value: '—'),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.account_balance_wallet_outlined, label: 'Pago por la entrega', value: '—'),
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
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primaryColor,
              value: _confirmado,
              onChanged: (value) => setState(() => _confirmado = value ?? false),
              title: const Text('Estoy listo para realizar esta entrega'),
              subtitle: const Text('Confirma que puedes recoger los productos.'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _guardando || !_confirmado ? null : _aceptarEntrega,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Aceptar y verificar recogida', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _guardando ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.TextSoft,
                side: const BorderSide(color: AppColors.TextSoft, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Volver', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _aceptarEntrega() async {
    if (widget.pedidoId == null) return;
    setState(() => _guardando = true);
    try {
      await DeliveryApiService.instance.acceptDelivery(widget.pedidoId!);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecogerPedidoRepartidor(pedidoId: widget.pedidoId),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorColor),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
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