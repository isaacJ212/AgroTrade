import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../services/productor_store.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/productor_widgets.dart';

class TableroImpacto extends StatelessWidget {
  const TableroImpacto({super.key});
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final ofertas = store.ofertas
            .where((o) => o.vigente(DateTime.now()))
            .toList();
        final cantidades = <String, double>{};
        double valor = 0;
        for (final o in ofertas) {
          final p = store.producto(o.productoId);
          if (p == null) continue;
          cantidades[p.unidad] = (cantidades[p.unidad] ?? 0) + o.cantidad;
          valor += o.cantidad * store.precioActual(p);
        }
        final activos = store.pedidos
            .where((p) => p.estado != EstadoPedido.rechazado)
            .toList();
        final listos = activos
            .where((p) => p.estado == EstadoPedido.listo)
            .length;
        final progreso = activos.isEmpty ? 0.0 : listos / activos.length;
        return ProductorPage(
          title: 'Mi impacto',
          children: [
            const Text(
              'Resumen de tus excedentes y pedidos.',
              style: AppTextStyles.SubTitle,
            ),
            const SizedBox(height: 20),
            ProductorStat(
              label: 'Excedentes en oferta',
              value: cantidades.isEmpty
                  ? '0'
                  : cantidades.entries
                        .map((e) => '${numero(e.value)} ${e.key}')
                        .join(' · '),
              icon: Icons.eco_outlined,
            ),
            ProductorStat(
              label: 'Valor de excedentes disponibles',
              value: dinero(valor),
              icon: Icons.payments_outlined,
            ),
            ProductorStat(
              label: 'Pedidos listos',
              value: '$listos',
              icon: Icons.check_circle_outline,
            ),
            ProductorCard(
              child: Column(
                children: [
                  const ProductorSection('Preparación de pedidos'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: progreso,
                            strokeWidth: 12,
                            color: AppColors.primaryColor,
                            backgroundColor: AppColors.primarySoftBg,
                          ),
                        ),
                        Text(
                          '${(progreso * 100).round()}%',
                          style: AppTextStyles.price,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('$listos de ${activos.length} pedidos listos'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
