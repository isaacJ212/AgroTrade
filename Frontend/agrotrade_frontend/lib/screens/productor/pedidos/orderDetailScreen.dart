import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../services/productor_store.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/productor_navigation.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String? pedidoId;
  const OrderDetailsScreen({super.key, this.pedidoId});
  Future<void> _rechazar(BuildContext context, PedidoRecibido pedido) async {
    final aceptar = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Rechazar pedido'),
        content: Text('El pedido ${pedido.codigo} pasará a rechazado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Volver'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    if (context.mounted && aceptar == true) {
      accionProductor(
        context,
        () => ProductorStore.instance.cambiarEstado(
          pedido.codigo,
          EstadoPedido.rechazado,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final p = pedidoId == null ? null : store.pedido(pedidoId!);
        if (p == null)
          return const ProductorPage(
            title: 'Detalle del pedido',
            children: [
              ProductorEmpty(
                'Selecciona un pedido de la lista para ver su detalle.',
              ),
            ],
          );
        return ProductorPage(
          title: 'Detalle del pedido',
          children: [
            ProductorCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.codigo, style: AppTextStyles.Title),
                  const SizedBox(height: 10),
                  ProductorStatus(
                    p.estado.label,
                    warning:
                        p.estado == EstadoPedido.pendiente ||
                        p.estado == EstadoPedido.rechazado,
                  ),
                  const SizedBox(height: 12),
                  Text(fechaCorta(p.fecha), style: AppTextStyles.SubTitle),
                ],
              ),
            ),
            const ProductorSection('Información del comprador'),
            ProductorCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.cliente, style: AppTextStyles.productoTitle),
                  const SizedBox(height: 8),
                  Text(p.direccion),
                  if (p.nota.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(p.nota),
                  ],
                  const SizedBox(height: 16),
                  ProductorButton(
                    label: 'Enviar mensaje al comprador',
                    outlined: true,
                    icon: Icons.chat_bubble_outline,
                    onPressed: () =>
                        ProductorNavigation.chat(context, p.cliente),
                  ),
                ],
              ),
            ),
            const ProductorSection('Productos del pedido'),
            ProductorCard(
              child: Column(
                children: [
                  for (final item in p.productos)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductorImage(
                            url: item.imagenUrl,
                            width: 64,
                            height: 64,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nombre,
                                  style: AppTextStyles.productoTitle,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${numero(item.cantidad)} ${item.unidad} × ${dinero(item.precio)}',
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dinero(item.total),
                                  style: AppTextStyles.label,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(child: Text('Subtotal')),
                      Text(dinero(p.subtotal)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(child: Text('Entrega')),
                      Text(dinero(p.envio)),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Total', style: AppTextStyles.Title),
                      ),
                      Flexible(
                        child: Text(
                          p.montoTexto,
                          style: AppTextStyles.statValue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (p.estado == EstadoPedido.pendiente) ...[
              ProductorButton(
                label: 'Confirmar pedido',
                icon: Icons.check,
                onPressed: () {
                  if (accionProductor(
                    context,
                    () => store.cambiarEstado(
                      p.codigo,
                      EstadoPedido.enPreparacion,
                    ),
                  )) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.prepareOrder,
                      arguments: p.codigo,
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              ProductorButton(
                label: 'Rechazar pedido',
                outlined: true,
                danger: true,
                onPressed: () => _rechazar(context, p),
              ),
            ],
            if (p.estado == EstadoPedido.enPreparacion ||
                p.estado == EstadoPedido.listo)
              ProductorButton(
                label: p.estado == EstadoPedido.listo
                    ? 'Ver preparación'
                    : 'Continuar preparación',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.prepareOrder,
                  arguments: p.codigo,
                ),
              ),
          ],
        );
      },
    );
  }
}
