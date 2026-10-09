import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'detalleEntregaRepartidor.dart';

class RutaEntregaRepartidor extends StatefulWidget {
  final int? pedidoId;
  const RutaEntregaRepartidor({super.key, this.pedidoId});

  @override
  State<RutaEntregaRepartidor> createState() => _RutaEntregaRepartidorState();
}

class _RutaEntregaRepartidorState extends State<RutaEntregaRepartidor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('Ruta de entrega #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              // Mapa placeholder
              Container(
                height: (constraints.maxHeight * 0.55).clamp(300.0, 400.0).toDouble(),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.map_outlined, size: 64, color: AppColors.primaryColor),
                      const SizedBox(height: 16),
                      Text('Mapa de ruta', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 8),
                      Text(
                        'El mapa se cargará cuando el backend exponga el endpoint de ruta',
                        style: AppTextStyles.SubTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tiempo estimado: — min | Distancia: — km',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Resumen de la ruta
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Tiempo estimado', style: AppTextStyles.SubTitle),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('— min', style: AppTextStyles.sectionTitle),
                            Text('— km', style: AppTextStyles.SubTitle),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.cardBorder),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primarySoftBg,
                          child: Icon(Icons.person_outline, color: AppColors.primaryColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Destinatario: —', style: AppTextStyles.productoTitle),
                              const SizedBox(height: 4),
                              Text('Destino: —', style: AppTextStyles.SubTitle),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Ver detalle del pedido',
                          icon: const Icon(Icons.info_outline, color: AppColors.primaryColor),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalleEntregaRepartidor(pedidoId: widget.pedidoId),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Recogida: —', style: AppTextStyles.SubTitle),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Text('Entrega #AT-${widget.pedidoId ?? '—'}', style: AppTextStyles.label),
                        _EstadoChip(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetalleEntregaRepartidor(pedidoId: widget.pedidoId)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Ver entrega', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          );
        },
      ),
    );
  }
}

class _EstadoChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.errorBg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFFFD0CB)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 14, color: AppColors.inputErrorColor),
        const SizedBox(width: 6),
        Text('Pendiente', style: AppTextStyles.chip.copyWith(color: AppColors.inputErrorColor)),
      ],
    ),
  );
}