import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../routes/app_routes.dart';
import '../../../services/productor_api_service.dart';
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
  List<PedidoRecibido> _apiPedidos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    print('DEBUG: [PedidosRecibidos] ══ Cargando pedidos del proveedor ══');
    setState(() => _cargando = true);
    final pedidos = await ProductorApiService.instance.getPedidosProveedor();
    if (mounted) {
      setState(() {
        _apiPedidos = pedidos;
        _cargando = false;
      });
      print('DEBUG: [PedidosRecibidos] Pedidos cargados: ${pedidos.length}');
    }
  }

  Future<void> _navegarYRecargar(String route, {Object? arguments}) async {
    print('DEBUG: [PedidosRecibidos] Navegando a $route');
    await Navigator.pushNamed(context, route, arguments: arguments);
    print('DEBUG: [PedidosRecibidos] Regresó de $route → recargando pedidos');
    _loadPedidos();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.embedded) return const ProductorShell(initialIndex: 2);
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final listaBase = _apiPedidos.isNotEmpty ? _apiPedidos : store.pedidos;
        final pedidos = listaBase
            .where((p) => _filtro == null || p.estado == _filtro)
            .toList();
        return ProductorPage(
          title: 'Pedidos recibidos',
          rootIndex: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadPedidos,
              tooltip: 'Actualizar pedidos',
            ),
          ],
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
            if (_cargando)
              const Center(child: CircularProgressIndicator())
            else if (pedidos.isEmpty)
              const ProductorEmpty('No hay pedidos en este estado.'),
            for (final pedido in pedidos)
              ProductorOrderTile(
                pedido: pedido,
                onTap: () => _navegarYRecargar(
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
