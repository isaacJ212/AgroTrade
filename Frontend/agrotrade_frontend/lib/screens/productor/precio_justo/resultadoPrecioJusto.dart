import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';

class ResultadoPrecioJusto extends StatelessWidget {
  final String nombreProducto, unidad;
  final double precioSugerido, costoTotal, margenGanancia;
  final List<Map<String, dynamic>> desglose;
  final bool permitirAplicar;
  const ResultadoPrecioJusto({
    super.key,
    required this.nombreProducto,
    required this.precioSugerido,
    required this.costoTotal,
    required this.margenGanancia,
    required this.unidad,
    required this.desglose,
    this.permitirAplicar = true,
  });
  @override
  Widget build(BuildContext context) {
    final valido =
        costoTotal.isFinite &&
        costoTotal > 0 &&
        precioSugerido.isFinite &&
        precioSugerido > 0;
    final margen = valido
        ? (precioSugerido - costoTotal) / costoTotal * 100
        : 0.0;
    return ProductorPage(
      title: 'Resultado del precio justo',
      children: [
        if (!valido)
          const ProductorEmpty('Realiza el cálculo antes de aplicar un precio.')
        else ...[
          ProductorCard(
            child: Column(
              children: [
                const Icon(
                  Icons.price_check,
                  size: 48,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(nombreProducto, style: AppTextStyles.Title),
                const SizedBox(height: 18),
                Text(dinero(precioSugerido), style: AppTextStyles.price),
                Text('por $unidad'),
                const SizedBox(height: 14),
                ProductorStatus('Margen: ${margen.toStringAsFixed(0)}%'),
              ],
            ),
          ),
          const ProductorSection('Desglose por unidad'),
          ProductorCard(
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Costo de producción')),
                    Text(dinero(costoTotal)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Text('Ganancia estimada')),
                    Text(dinero(precioSugerido - costoTotal)),
                  ],
                ),
              ],
            ),
          ),
          ProductorButton(
            label: permitirAplicar ? 'Aplicar precio' : 'Listo',
            onPressed: () =>
                Navigator.pop(context, permitirAplicar ? precioSugerido : null),
          ),
          const SizedBox(height: 12),
        ],
        ProductorButton(
          label: 'Volver a calcular',
          outlined: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
