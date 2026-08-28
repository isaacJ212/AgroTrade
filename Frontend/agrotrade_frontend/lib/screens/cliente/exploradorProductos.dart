import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'inicioComprador.dart';


class ProductoMercado {
  final int id;
  final String nombre;
  final String finca;
  final double precio;
  final String unidad;
  final String distancia;
  final String categoria;
  final bool pocoInventario;
  final String imagenUrl;

  const ProductoMercado({
    required this.id,
    required this.nombre,
    required this.finca,
    required this.precio,
    required this.unidad,
    required this.distancia,
    required this.categoria,
    required this.imagenUrl,
    this.pocoInventario = false,
  });
}

class ExploradorProductos extends StatefulWidget {
  const ExploradorProductos({super.key});

  @override
  State<ExploradorProductos> createState() => _ExploradorProductosState();
}

class _ExploradorProductosState extends State<ExploradorProductos> {
  int _tabSel = 0;
  String _busqueda = '';

  
  final Set<int> _favoritos = {};

  static const List<String> _tabLabels = ['Todos', 'Frutas', 'Cítricos', 'Verduras'];


  static const List<ProductoMercado> _productos = [
    ProductoMercado(
      id: 1,
      nombre: 'Tomate',
      finca: 'Finca La Esperanza',
      precio: 25.00,
      unidad: 'lb',
      distancia: '4.2 km',
      categoria: 'Verduras',
      imagenUrl: 'https://images.unsplash.com/photo-1546094096-0df9bdcaaadd?auto=format&fit=crop&w=800&q=60',
    ),
    ProductoMercado(
      id: 2,
      nombre: 'Naranja',
      finca: 'Coop. Los Andes',
      precio: 18.00,
      unidad: 'doc',
      distancia: '6.1 km',
      categoria: 'Cítricos',
      imagenUrl: 'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=800&q=60',
    ),
    ProductoMercado(
      id: 3,
      nombre: 'Limón',
      finca: 'Finca San José',
      precio: 20.00,
      unidad: 'lb',
      distancia: '3.8 km',
      categoria: 'Cítricos',
      pocoInventario: true,
      imagenUrl: 'https://images.unsplash.com/photo-1590502591965-156b8b3f0e53?auto=format&fit=crop&w=800&q=60',
    ),
    ProductoMercado(
      id: 4,
      nombre: 'Manzana Roja',
      finca: 'Finca El Carmen',
      precio: 32.00,
      unidad: 'lb',
      distancia: '7.5 km',
      categoria: 'Frutas',
      imagenUrl: 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=800&q=60',
    ),
  ];


  List<ProductoMercado> get _filtrados => _productos.where((p) {
        final porTab = _tabSel == 0 || p.categoria == _tabLabels[_tabSel];
        final texto = _busqueda.trim().toLowerCase();
        final porTexto = texto.isEmpty || p.nombre.toLowerCase().contains(texto);
        return porTab && porTexto;
      }).toList();

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }


  void _toggleFavorito(int id) {
    setState(() {
      _favoritos.contains(id) ? _favoritos.remove(id) : _favoritos.add(id);
    });
  }

  void _agregar(String nombre) {
    _mostrarSnack('$nombre agregado al carrito 🛒');
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
    _mostrarSnack('Esta sección estará disponible pronto 🌱');
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
            Expanded(child: _lista()),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
          NavElemento(label: 'Explorar', icon: Icons.search_outlined, activeIcon: Icons.search),
          NavElemento(label: 'Pedidos', icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
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
          const Icon(Icons.menu, color: AppColors.titleDark, size: 22),
          Expanded(
            child: Center(
              child: Text(
                'AgroTrade',
                style: AppTextStyles.wordmark.copyWith(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.titleDark, size: 22),
            onPressed: () => _mostrarSnack('Carrito próximamente 🛒'),
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
                  color: AppColors.inputBorderColor.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, size: 20, color: AppColors.bodyText),
                  const SizedBox(width: 8),
                  Expanded(
                    
                    child: TextField(
                      onChanged: (v) => setState(() => _busqueda = v),
                      decoration: InputDecoration(
                        hintText: 'Buscar productos',
                        hintStyle: AppTextStyles.SubTitle.copyWith(
                          fontSize: 13,
                          color: AppColors.bodyText.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _mostrarSnack('Filtros avanzados próximamente ⚙️'),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.tune, color: AppColors.primaryColor, size: 20),
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
        children: [
          for (int i = 0; i < _tabLabels.length; i++) _tab(i),
        ],
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
            Icon(Icons.search_off, size: 40, color: AppColors.bodyText),
            const SizedBox(height: 8),
            Text('No se encontraron productos',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) => _ProductoExploradorCard(
        producto: productos[i],
        favorito: _favoritos.contains(productos[i].id),
        onFavorito: () => _toggleFavorito(productos[i].id),
        onAgregar: () => _agregar(productos[i].nombre),
      ),
    );
  }
}


class _ProductoExploradorCard extends StatelessWidget {
  final ProductoMercado producto;
  final bool favorito;
  final VoidCallback onFavorito;
  final VoidCallback onAgregar;

  const _ProductoExploradorCard({
    required this.producto,
    required this.favorito,
    required this.onFavorito,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias, 
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Stack(
            children: [
              Image.network(
                producto.imagenUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 170,
                  color: AppColors.tileBg,
                  child: const Icon(Icons.image_not_supported_outlined,
                      size: 32, color: AppColors.bodyText),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: onFavorito,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.White.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                   
                      favorito ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: favorito ? AppColors.amber : AppColors.bodyText,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        producto.nombre,
                        style: AppTextStyles.productoTitle.copyWith(fontSize: 17),
                      ),
                    ),
                   
                    producto.pocoInventario
                        ? StatusChip(
                            label: 'Poco inventario',
                            background: AppColors.chipGrey,
                            color: AppColors.titleDark,
                            icon: Icons.circle,
                            iconColor: AppColors.amber,
                            radius: 8,
                          )
                        : StatusChip(
                            label: 'Disponible',
                            background: AppColors.navPill,
                            color: AppColors.primaryColor,
                            icon: Icons.circle,
                            radius: 8,
                          ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.storefront_outlined,
                        size: 14, color: AppColors.bodyText),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        producto.finca,
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'C\$ ${producto.precio.toStringAsFixed(2)}',
                                style: AppTextStyles.statValue.copyWith(fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2, left: 3),
                                child: Text(
                                  '/${producto.unidad}',
                                  style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 14, color: AppColors.bodyText),
                              const SizedBox(width: 4),
                              Text(
                                producto.distancia,
                                style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                   
                    GestureDetector(
                      onTap: onAgregar,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add_shopping_cart,
                                color: AppColors.White, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Agregar',
                              style: TextStyle(
                                color: AppColors.White,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}