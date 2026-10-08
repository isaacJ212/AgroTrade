import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'aceptarEntregaRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import '../../services/delivery_api_service.dart';

class DetalleEntregaRepartidor extends StatefulWidget {
  final int? pedidoId;
  final String? zonaEntrega;
  final double? totalPedido;

  const DetalleEntregaRepartidor({
    super.key,
    this.pedidoId,
    this.zonaEntrega,
    this.totalPedido,
  });

  @override
  State<DetalleEntregaRepartidor> createState() => _DetalleEntregaRepartidorState();
}

class _DetalleEntregaRepartidorState extends State<DetalleEntregaRepartidor> {
  late final Future<Map<String, dynamic>?> _detalleFuture;

  @override
  void initState() {
    super.initState();
    if (widget.pedidoId != null) {
      _detalleFuture = _cargarDetalle();
    } else {
      _detalleFuture = Future.value(null);
    }
  }

  Future<Map<String, dynamic>?> _cargarDetalle() async {
    if (widget.pedidoId == null) return null;
    try {
      // Try to get more detailed info from the API if available
      final response = await DeliveryApiService.instance.getDetalleEntrega(widget.pedidoId!);
      return response;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('Entrega #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _detalleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          final detalle = snapshot.data;
          final zona = widget.zonaEntrega ?? detalle?['zonaEntrega'] ?? '—';
          final total = widget.totalPedido ?? (detalle?['totalPedido'] as double?) ?? 0.0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoftBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Entrega #AT-${widget.pedidoId ?? '—'}',
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.errorBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFFD0CB)),
                            ),
                            child: Text(
                              'Pendiente de recogida',
                              style: AppTextStyles.chip.copyWith(color: AppColors.inputErrorColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Información de la entrega
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
                    Text('Información de la entrega', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Zona de entrega',
                      value: widget.zonaEntrega ?? '—',
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.schedule_outlined,
                      label: 'Fecha de creación',
                      value: '—', // API no provee esta info en detalle
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.storefront_outlined,
                      label: 'Punto de recogida',
                      value: 'Por confirmar', // API no provee esta info
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: 'Cliente',
                      value: '—', // API no provee esta info
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Total
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
                    Text('Resumen económico', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoRow(
                            icon: Icons.receipt_long_outlined,
                            label: 'Total pedido',
                            value: '\$${widget.totalPedido?.toStringAsFixed(2) ?? total.toStringAsFixed(2)}',
                          ),
                        ),
                        Expanded(
                          child: _InfoRow(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Tu pago',
                            value: '—', // API no provee esta info
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Nota
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
                    Text('Nota', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    Text(
                      'La información detallada (productos, cliente, indicaciones) se cargará cuando el backend exponga el endpoint de detalle de entrega.',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botones de acción
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AceptarEntregaRepartidor(pedidoId: widget.pedidoId ?? 0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Aceptar entrega', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RutaEntregaRepartidor(pedidoId: widget.pedidoId ?? 0),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentBlue,
                    side: const BorderSide(color: AppColors.accentBlue, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Ver ruta', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => _mostrarInfoContacto(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.TextSoft,
                    side: const BorderSide(color: AppColors.TextSoft, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Información de contacto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mostrarInfoContacto(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Información de contacto'),
        content: Text(
          'Zona de entrega: ${widget.zonaEntrega ?? '—'}\n\n'
          'Mensajes y llamadas no disponibles en esta versión.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}