import 'package:flutter/material.dart';
import '../../routes/productor_navigation.dart';
import '../../services/productor_store.dart';
import 'inicioProductor.dart';
import 'inventario/inventarioProductor.dart';
import 'pedidos/pedidosRecibidos.dart';
import 'perfilFinca.dart';

class ProductorShell extends StatefulWidget {
  final int initialIndex;
  const ProductorShell({super.key, this.initialIndex = 0});
  @override
  State<ProductorShell> createState() => _ProductorShellState();
}

class _ProductorShellState extends State<ProductorShell> {
  late int _index = widget.initialIndex;
  @override
  void initState() {
    super.initState();
    ProductorStore.instance.asegurarSesion();
  }

  @override
  Widget build(BuildContext context) => ProductorNavigation(
    onTab: (index) {
      if (index != _index) setState(() => _index = index);
    },
    child: PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _index != 0) setState(() => _index = 0);
      },
      child: IndexedStack(
        index: _index,
        children: const [
          InicioProductor(embedded: true),
          InventarioProductor(embedded: true),
          PedidosRecibidos(embedded: true),
          PerfilFinca(embedded: true),
        ],
      ),
    ),
  );
}
