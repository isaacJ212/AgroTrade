import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/productor_models.dart';
import '../../services/productor_store.dart';
import '../../routes/app_routes.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/productor_widgets.dart';

class MapaCalorDemanda extends StatefulWidget {
  const MapaCalorDemanda({super.key});
  @override
  State<MapaCalorDemanda> createState() => _MapaCalorDemandaState();
}

class _MapaCalorDemandaState extends State<MapaCalorDemanda> {
  int? _productoId;
  int _dias = 30;
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final productos = store.productos;
        final id =
            _productoId ?? (productos.isEmpty ? null : productos.first.id);
        final p = id == null ? null : store.producto(id);
        final now = DateTime.now();
        final desde = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: _dias - 1));
        final pedidos = store.pedidos
            .where(
              (pedido) =>
                  pedido.estado != EstadoPedido.rechazado &&
                  !pedido.fecha.isBefore(desde) &&
                  !pedido.fecha.isAfter(now) &&
                  pedido.productos.any((item) => item.productoId == id),
            )
            .toList();
        final zonas = <String, double>{};
        for (final pedido in pedidos) {
          zonas[pedido.direccion] =
              (zonas[pedido.direccion] ?? 0) +
              pedido.productos
                  .where((item) => item.productoId == id)
                  .fold<double>(0, (sum, item) => sum + item.cantidad);
        }
        final ordenadas = zonas.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return ProductorPage(
          title: 'Mapa de demanda',
          actions: [
            IconButton(
              tooltip: 'Copiar reporte de demanda',
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: [
                      'Demanda: ${p?.nombre ?? 'Sin producto'} · $_dias días',
                      for (final z in ordenadas)
                        '${z.key}: ${numero(z.value)} ${p?.unidad ?? ''}',
                    ].join('\n'),
                  ),
                );
                if (context.mounted)
                  mensajeProductor(context, 'Reporte de demanda copiado.');
              },
            ),
          ],
          children: [
            if (productos.isEmpty)
              const ProductorEmpty(
                'Agrega productos para consultar su demanda.',
              )
            else ...[
              DropdownButtonFormField<int>(
                value: id,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Producto'),
                items: productos
                    .map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.nombre, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _productoId = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _dias,
                decoration: const InputDecoration(labelText: 'Período'),
                items: [7, 30, 90]
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text('Últimos $v días'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _dias = v!),
              ),
              const SizedBox(height: 20),
              ProductorMap(
                label: ordenadas.isEmpty
                    ? store.finca.ubicacion
                    : ordenadas.first.key,
              ),
              const SizedBox(height: 12),
              const Text(
                'Demanda según los pedidos recibidos por zona.',
                style: AppTextStyles.SubTitle,
              ),
              const ProductorSection('Zonas con mayor demanda'),
              if (ordenadas.isEmpty)
                const ProductorEmpty(
                  'No hay pedidos de este producto en el período seleccionado.',
                ),
              for (final zona in ordenadas)
                ProductorCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(zona.key, style: AppTextStyles.productoTitle),
                      const SizedBox(height: 10),
                      Text(
                        '${numero(zona.value)} ${p?.unidad ?? ''} solicitados',
                        style: AppTextStyles.SubTitle,
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: zona.value / ordenadas.first.value,
                        minHeight: 8,
                        backgroundColor: AppColors.primarySoftBg,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(height: 12),
                      ProductorButton(
                        label: 'Ver pedidos',
                        outlined: true,
                        onPressed: () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (sheet) => SafeArea(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ProductorSection(zona.key),
                                  for (final pedido in pedidos.where(
                                    (item) => item.direccion == zona.key,
                                  ))
                                    ProductorOrderTile(
                                      pedido: pedido,
                                      onTap: () {
                                        Navigator.pop(sheet);
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.orderDetail,
                                          arguments: pedido.codigo,
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              ProductorButton(
                label: 'Crear oferta de este producto',
                onPressed: p == null || p.cantidad <= 0
                    ? null
                    : () => Navigator.pushNamed(
                        context,
                        AppRoutes.crearOferta,
                        arguments: p,
                      ),
              ),
            ],
          ],
        );
      },
    );
  }
}
