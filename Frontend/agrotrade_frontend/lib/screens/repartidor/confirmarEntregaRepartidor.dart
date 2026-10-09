import 'package:flutter/material.dart';
import '../../services/delivery_api_service.dart';
import '../../ui/app_theme.dart';
import 'homeRepartidor.dart';

class ConfirmarEntregaRepartidor extends StatefulWidget {
  final int? pedidoId;
  const ConfirmarEntregaRepartidor({super.key, this.pedidoId});

  @override
  State<ConfirmarEntregaRepartidor> createState() =>
      _ConfirmarEntregaRepartidorState();
}

class _ConfirmarEntregaRepartidorState
    extends State<ConfirmarEntregaRepartidor> {
  bool _confirmado = false;
  bool _guardando = false;
  final _nota = TextEditingController();

  @override
  void dispose() {
    _nota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Confirmar entrega #AT-${widget.pedidoId ?? '—'}',
          style: AppTextStyles.Title,
        ),
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
                Text(
                  'Entrega #AT-${widget.pedidoId ?? '—'}',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Destinatario',
                  value: '—',
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Destino',
                  value: '—',
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Pago de esta entrega',
                  value: '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryColor,
                  value: _confirmado,
                  onChanged: (value) =>
                      setState(() => _confirmado = value ?? false),
                  title: const Text(
                    'Confirmo que entregué todos los productos al cliente.',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nota de entrega (opcional)',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nota,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Observaciones sobre la entrega.',
                    filled: true,
                    fillColor: AppColors.scaffoldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _guardando || !_confirmado ? null : _confirmarEntrega,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirmar entrega',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Al confirmar, se actualizarán tus entregas y ganancias.',
            textAlign: TextAlign.center,
            style: AppTextStyles.SubTitle,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEntrega() async {
    if (widget.pedidoId == null) return;
    setState(() => _guardando = true);
    try {
      await DeliveryApiService.instance.confirmarEntrega(widget.pedidoId!, _nota.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrega completada correctamente.'),
          backgroundColor: AppColors.primaryColor,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const InicioRepartidor()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.errorColor,
        ),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

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
                Text(
                  label,
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                ),
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
