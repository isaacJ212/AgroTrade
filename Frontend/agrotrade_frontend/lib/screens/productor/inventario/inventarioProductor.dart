import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../routes/app_routes.dart';
import '../../../services/productor_store.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';
import '../productorShell.dart';
import '../../../services/productor_api_service.dart';
export '../../../models/productor_models.dart'
    show Producto, Costo, EstadoProducto;

class InventarioProductor extends StatefulWidget {
  final bool embedded;
  const InventarioProductor({super.key, this.embedded = false});
  @override
  State<InventarioProductor> createState() => _InventarioProductorState();
}

class _InventarioProductorState extends State<InventarioProductor> {
  String _busqueda = '';
  EstadoProducto? _filtro;
  List<Producto> _apiProductos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _loadInventario();
  }

  Future<void> _loadInventario() async {
    print('DEBUG: [InventarioProductor] ══ Cargando inventario ══');
    setState(() => _cargando = true);
    final inventario = await ProductorApiService.instance.getInventario();
    if (mounted) {
      setState(() {
        _apiProductos = inventario;
        _cargando = false;
      });
      print('DEBUG: [InventarioProductor] Productos mostrados: ${inventario.length}');
    }
  }

  Future<void> _navegarYRecargar(String route, {Object? arguments}) async {
    print('DEBUG: [InventarioProductor] Navegando a $route');
    await Navigator.pushNamed(context, route, arguments: arguments);
    print('DEBUG: [InventarioProductor] Regresó de $route → recargando inventario');
    _loadInventario();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.embedded) return const ProductorShell(initialIndex: 1);
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final List<Producto> listaBase = _apiProductos.isNotEmpty ? _apiProductos : store.productos;
        final productos = listaBase
            .where(
              (p) =>
                  (_filtro == null || p.estado == _filtro) &&
                  p.nombre.toLowerCase().contains(
                    _busqueda.trim().toLowerCase(),
                  ),
            )
            .toList();
        return ProductorPage(
          title: 'Mi inventario',
          rootIndex: 1,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Agregar producto'),
            onPressed: () => _navegarYRecargar(AppRoutes.agregarProducto),
          ),
          children: [
            TextField(
              onChanged: (value) => setState(() => _busqueda = value),
              decoration: const InputDecoration(
                hintText: 'Buscar productos',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: _filtro == null,
                  onSelected: (_) => setState(() => _filtro = null),
                ),
                for (final estado in EstadoProducto.values)
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
            else if (productos.isEmpty)
              const ProductorEmpty('No hay productos para esta búsqueda.'),
            for (final p in productos)
              ProductorCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => _navegarYRecargar(
                        AppRoutes.detalleProductoProductor,
                        arguments: p,
                      ),
                      child: ProductorImage(
                        url: p.imagenUrl,
                        bytes: p.fotos.isEmpty ? null : p.fotos.first,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(p.nombre, style: AppTextStyles.productoTitle),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ProductorStatus(
                          p.estado.label,
                          warning: p.estado != EstadoProducto.disponible,
                        ),
                        if (!p.publicado)
                          const ProductorStatus('No publicado', warning: true),
                        if (store.oferta(p.id) case final oferta?)
                          ProductorStatus(
                            oferta.vigente(DateTime.now())
                                ? 'Oferta activa'
                                : 'Oferta guardada',
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(p.cantidadTexto, style: AppTextStyles.SubTitle),
                    const SizedBox(height: 4),
                    Text(
                      '${dinero(store.precioActual(p))} / ${p.unidad}',
                      style: AppTextStyles.statValue,
                    ),
                    const SizedBox(height: 12),
                    ProductorButton(
                      label: 'Ver producto',
                      outlined: true,
                      onPressed: () => _navegarYRecargar(
                        AppRoutes.detalleProductoProductor,
                        arguments: p,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
