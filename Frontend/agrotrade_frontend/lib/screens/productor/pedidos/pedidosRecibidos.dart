import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../routes/app_routes.dart';
import '../../../services/productor_store.dart';
import '../../../ui/widgets/productor_widgets.dart';
import '../productorShell.dart';
export '../../../models/productor_models.dart'
    show PedidoRecibido, EstadoPedido;

class PedidosRecibidos extends StatefulWidget {
  final bool embedded;
  const PedidosRecibidos({super.key, this.embedded = false});
  @override
  State<PedidosRecibidos> createState() => _PedidosRecibidosState();
}

class _PedidosRecibidosState extends State<PedidosRecibidos> {
  EstadoPedido? _filtro;
  @override
  Widget build(BuildContext context) {
    if (!widget.embedded) return const ProductorShell(initialIndex: 2);
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final pedidos = store.pedidos
            .where((p) => _filtro == null || p.estado == _filtro)
            .toList();
        return ProductorPage(
          title: 'Pedidos recibidos',
          rootIndex: 2,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: _filtro == null,
                  onSelected: (_) => setState(() => _filtro = null),
                ),
                for (final estado in EstadoPedido.values)
                  ChoiceChip(
                    label: Text(estado.label),
                    selected: _filtro == estado,
                    onSelected: (_) => setState(() => _filtro = estado),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (pedidos.isEmpty)
              const ProductorEmpty('No hay pedidos en este estado.'),
            for (final pedido in pedidos)
              ProductorOrderTile(
                pedido: pedido,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.orderDetail,
                  arguments: pedido.codigo,
                ),
              ),
          ],
        );
      },
    );
  }
}
