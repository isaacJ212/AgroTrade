import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/productor_models.dart';
import '../../../services/productor_store.dart';
import '../../../routes/app_routes.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';

class Sales extends StatefulWidget {
  final bool reporte;
  const Sales({super.key, this.reporte = false});
  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  int _dias = 30;
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final now = DateTime.now();
        final inicio = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: _dias - 1));
        final pedidos = store.pedidos
            .where(
              (p) =>
                  p.estado == EstadoPedido.listo &&
                  !p.fecha.isBefore(inicio) &&
                  !p.fecha.isAfter(now),
            )
            .toList();
        final total = pedidos.fold<double>(0, (sum, p) => sum + p.subtotal);
        final promedio = pedidos.isEmpty ? 0.0 : total / pedidos.length;
        final vendidos = <String, double>{};
        for (final p in pedidos) {
          for (final item in p.productos) {
            final clave = '${item.nombre} (${item.unidad})';
            vendidos[clave] = (vendidos[clave] ?? 0) + item.cantidad;
          }
        }
        final ranking = vendidos.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final buckets = List<double>.filled(6, 0);
        for (final p in pedidos) {
          final index = math.min(
            5,
            math.max(
              0,
              (p.fecha.difference(inicio).inDays * 6 / _dias).floor(),
            ),
          );
          buckets[index] += p.subtotal;
        }
        final maximo = buckets.fold<double>(0, math.max);
        return ProductorPage(
          title: widget.reporte ? 'Reporte de ventas' : 'Mis ventas',
          actions: [
            IconButton(
              tooltip: 'Copiar reporte',
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                final lines = [
                  'Reporte de ventas · últimos $_dias días',
                  'Pedidos listos: ${pedidos.length}',
                  'Subtotal de productos: ${dinero(total)}',
                  for (final p in pedidos)
                    '${p.codigo} · ${p.cliente} · ${dinero(p.subtotal)}',
                ];
                await Clipboard.setData(ClipboardData(text: lines.join('\n')));
                if (context.mounted)
                  mensajeProductor(context, 'Reporte copiado.');
              },
            ),
          ],
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final dias in [7, 30, 90])
                  ChoiceChip(
                    label: Text('$dias días'),
                    selected: _dias == dias,
                    onSelected: (_) => setState(() => _dias = dias),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ProductorStat(
              label: 'Productos de pedidos listos',
              value: dinero(total),
              icon: Icons.payments_outlined,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ProductorStat(
                    label: 'Pedidos',
                    value: '${pedidos.length}',
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProductorStat(
                    label: 'Promedio por pedido',
                    value: dinero(promedio),
                    icon: Icons.bar_chart,
                  ),
                ),
              ],
            ),
            const Text(
              'Los importes corresponden a productos de pedidos listos; no incluyen la entrega ni confirman el cobro.',
              style: AppTextStyles.SubTitle,
            ),
            const SizedBox(height: 16),
            const ProductorSection('Ventas del período'),
            ProductorCard(
              child: SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < buckets.length; i++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: maximo <= 0
                                    ? 3
                                    : 3 + buckets[i] / maximo * 100,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${1 + (i * _dias / 6).floor()}',
                                style: AppTextStyles.SubTitle,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Text(
              'Días transcurridos desde el inicio del período.',
              style: AppTextStyles.SubTitle,
            ),
            const ProductorSection('Productos más vendidos'),
            if (ranking.isEmpty)
              const ProductorEmpty('No hay pedidos listos en este período.'),
            for (final item in ranking.take(5))
              ProductorCard(
                child: Row(
                  children: [
                    Expanded(child: Text(item.key)),
                    const SizedBox(width: 12),
                    Text(numero(item.value), style: AppTextStyles.label),
                  ],
                ),
              ),
            if (widget.reporte) ...[
              const ProductorSection('Detalle de pedidos'),
              for (final p in pedidos)
                ProductorOrderTile(
                  pedido: p,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.orderDetail,
                    arguments: p.codigo,
                  ),
                ),
            ] else
              ProductorButton(
                label: 'Ver reporte completo',
                outlined: true,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Sales(reporte: true)),
                ),
              ),
          ],
        );
      },
    );
  }
}
