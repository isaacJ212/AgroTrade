import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../shared/profile.dart';
import 'buscarProductos.dart';
import 'carrito.dart';
import 'inicioComprador.dart';
import 'misPedidos.dart';
import 'perfilProductor.dart';
import 'detalleProductoCliente.dart';
import '../../models/Consumidor/consumidor_models.dart';
import '../../services/consumer_api_service.dart';
import '../../services/cart_service.dart';

class ExploradorProductos extends StatefulWidget {
  const ExploradorProductos({super.key});

  @override
  State<ExploradorProductos> createState() => _ExploradorProductosState();
}

class _ExploradorProductosState extends State<ExploradorProductos> {
  int _tabSel = 0;
  String _busqueda = '';
  final Set<int> _favoritos = {};
  
  List<ProductoMercado> _productos = [];
  bool _cargando = true;
  int _page = 1;
  int _totalPages = 1;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _cargarProductos();
  }

  Future<void> _cargarCategorias() async {
    try {
      final cats = await ConsumerApiService.instance.getCategoriasActivas();
      if (cats.isNotEmpty) {
        final unicas = cats.toSet().toList();
        unicas.insert(0, 'Todos');
        if (mounted) {
          setState(() {
            _tabLabels = unicas;
            // Si la categoría seleccionada actual es mayor al nuevo número de pestañas,
            // la reiniciamos a 0 ("Todos")
            if (_tabSel >= _tabLabels.length) {
              _tabSel = 0;
            }
          });
        }
      }
    } catch (_) {
      // Fallback a las categorías por defecto si hay error de red
    }
  }

  void _onSearchChanged(String val) {
    setState(() => _busqueda = val);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _page = 1;
        _cargarProductos();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    setState(() => _cargando = true);
    final response = await ConsumerApiService.instance.getProductos(
      page: _page, 
      limit: 20,
      search: _busqueda.trim()
    );
    if (mounted) {
      setState(() {
        _productos = response.items;
        _totalPages = response.totalPages;
        _cargando = false;
      });
    }
  }

  List<String> _tabLabels = [
    'Todos',
    'Frutas',
    'Cítricos',
    'Verduras',
  ];

  List<ProductoMercado> get _filtrados => _productos.where((p) {
    final porTab = _tabSel == 0 || p.categoria.toLowerCase() == _tabLabels[_tabSel].toLowerCase();
    return porTab;
  }).toList();

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorito(int id) {
    setState(() {
      _favoritos.contains(id) ? _favoritos.remove(id) : _favoritos.add(id);
    });
  }

  void _agregar(ProductoMercado producto) {
    CartService.instance.addItem(ItemCarrito(
      id: producto.id,
      nombre: producto.nombre,
      finca: producto.finca,
      unidad: producto.unidad,
      precioUnitario: producto.precio,
      cantidad: 1,
      imagenUrl: producto.imagenUrl,
    ));
    _mostrarSnack('${producto.nombre} agregado al carrito 🛒');
  }

  void _irATab(int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioComprador()),
      );
      return;
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MisPedidosScreen()),
      );
      return;
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Profile()),
      );
      return;
    }
  }

  Widget _paginacionWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: AppColors.White,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: _page > 1 && !_cargando
                ? () {
                    _page--;
                    _cargarProductos();
                  }
                : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Anterior'),
          ),
          Text('Página $_page de ${max(1, _totalPages)}'),
          TextButton(
            onPressed: _page < _totalPages && !_cargando
                ? () {
                    _page++;
                    _cargarProductos();
                  }
                : null,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Siguiente'), Icon(Icons.chevron_right)],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _encabezado(),
            _filaBusqueda(),
            const SizedBox(height: 8),
            _tabs(),
            const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: _cargando 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
              : _lista(),
            ),
            _paginacionWidget(),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(
            label: 'Inicio',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          NavElemento(
            label: 'Explorar',
            icon: Icons.search_outlined,
            activeIcon: Icons.search,
          ),
          NavElemento(
            label: 'Pedidos',
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
          ),
          NavElemento(
            label: 'Perfil',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
        currentIndex: 1,
        onTap: _irATab,
      ),
    );
  }

  Widget _encabezado() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const InicioComprador()),
                );
              }
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Catálogo del Mercado',
                style: AppTextStyles.Title.copyWith(fontSize: 18),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: CartService.instance,
            builder: (context, _) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: CartService.instance.totalItems > 0,
                  label: Text('${CartService.instance.totalItems}'),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.titleDark,
                    size: 22,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarritoScreen()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _filaBusqueda() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.screenBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.inputBorderColor.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, size: 20, color: AppColors.bodyText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Buscar productos',
                        hintStyle: AppTextStyles.SubTitle.copyWith(
                          fontSize: 13,
                          color: AppColors.bodyText.withValues(alpha: 0.7),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BuscarProductos()),
            ),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [for (int i = 0; i < _tabLabels.length; i++) _tab(i)],
      ),
    );
  }

  Widget _tab(int index) {
    final activo = _tabSel == index;
    return GestureDetector(
      onTap: () => setState(() => _tabSel = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              _tabLabels[index],
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                color: activo ? AppColors.primarySoft : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              color: activo ? AppColors.primaryColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _lista() {
    final productos = _filtrados;
    if (productos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 40, color: AppColors.bodyText),
            const SizedBox(height: 8),
            Text(
              'No se encontraron productos',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _ProductoCard(
        producto: productos[i],
        esFavorito: _favoritos.contains(productos[i].id),
        onFavorito: () => _toggleFavorito(productos[i].id),
        onAgregar: () => _agregar(productos[i]),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProductoCliente(producto: productos[i]),
          ),
        ),
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final ProductoMercado producto;
  final bool esFavorito;
  final VoidCallback onFavorito;
  final VoidCallback onAgregar;
  final VoidCallback onTap;

  const _ProductoCard({
    required this.producto,
    required this.esFavorito,
    required this.onFavorito,
    required this.onAgregar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  producto.imagenUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: AppColors.tileBg,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 36,
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.White.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          producto.distancia,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.titleDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavorito,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.White.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        esFavorito ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: esFavorito ? Colors.red : AppColors.titleDark,
                      ),
                    ),
                  ),
                ),
                if (producto.pocoInventario)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Poco inventario',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.amber,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.titleDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          producto.finca,
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'C\$ ${producto.precio.toStringAsFixed(2)}',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Text(
                              ' / ${producto.unidad}',
                              style: AppTextStyles.SubTitle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onAgregar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Agregar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
