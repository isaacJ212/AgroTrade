import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../shared/profile.dart';
import 'buscarProductos.dart';
import 'carrito.dart';
import 'exploradorProductos.dart';
import 'misPedidos.dart';
import 'perfilProductor.dart';
import '../../models/Consumidor/consumidor_models.dart';
import '../../services/consumer_api_service.dart';
import '../../services/cart_service.dart';
class CategoriaMercado {
  final String label;
  final IconData icon;
  final Color bg;
  final Color color;

  const CategoriaMercado(this.label, this.icon, this.bg, this.color);
}

class ProductorDestacado {
  final String nombre;
  final double rating;
  final int ventas;
  final bool verificado;
  final String avatarUrl;
  final String tipo;
  final String? portadaUrl;
  final String? ubicacion;
  final String? descripcion;

  const ProductorDestacado({
    required this.nombre,
    required this.rating,
    required this.ventas,
    required this.verificado,
    required this.avatarUrl,
    this.tipo = 'Finca',
    this.portadaUrl,
    this.ubicacion,
    this.descripcion,
  });
}

const cooperativaLosAndes = ProductorDestacado(
  nombre: 'Cooperativa Los Andes',
  rating: 4.9,
  ventas: 120,
  verificado: true,
  avatarUrl: 'https://www.cooperativasextremadura.es/media/files/999-media.jpg',
  portadaUrl:
      'https://eos.com/wp-content/uploads/2020/06/AGRICULTURAL-COOPERATIVES-img.jpg',
  ubicacion: 'Diriamba, Carazo',
  descripcion:
      'Dedicados a la producción agrícola sostenible '
      'desde hace más de 20 años.',
);

const fincaLaEsperanza = ProductorDestacado(
  nombre: 'Finca La Esperanza',
  rating: 4.7,
  ventas: 85,
  verificado: false,
  avatarUrl:
      'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=200&q=60',
  portadaUrl:
      'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=1200&q=80',
  ubicacion: 'Jinotepe, Carazo',
  descripcion:
      'Dedicados a la producción agrícola sostenible '
      'desde hace más de 20 años. En Finca La Esperanza, '
      'cultivamos nuestras tierras respetando los ciclos '
      'naturales y utilizando prácticas amigables con el '
      'medio ambiente para ofrecer los productos más '
      'frescos de la región.',
);

class InicioComprador extends StatefulWidget {
  const InicioComprador({super.key});

  @override
  State<InicioComprador> createState() => _InicioCompradorState();
}

class _InicioCompradorState extends State<InicioComprador> {
  int _categoriaSel = 1;

  List<ProductoCercano> _cercanos = [];
  OfertaExcedente? _oferta;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final cercanos = await ConsumerApiService.instance.getProductosCercanos();
    final oferta = await ConsumerApiService.instance.getOfertaDia();
    if (mounted) {
      setState(() {
        _cercanos = cercanos;
        _oferta = oferta;
        _cargando = false;
      });
    }
  }

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  static const List<ProductorDestacado> _productores = [
    cooperativaLosAndes,
    fincaLaEsperanza,
  ];

  static const List<CategoriaMercado> _listaCategorias = [
    CategoriaMercado(
      'Frutas',
      Icons.apple,
      AppColors.navPill,
      AppColors.primaryColor,
    ),
    CategoriaMercado(
      'Cítricos',
      Icons.eco,
      AppColors.blueSoft,
      AppColors.accentBlue,
    ),
    CategoriaMercado(
      'Verduras',
      Icons.grass,
      AppColors.navPill,
      AppColors.primaryColor,
    ),
    CategoriaMercado(
      'Otros',
      Icons.category,
      AppColors.tileBg,
      AppColors.titleDark,
    ),
  ];

  void _agregarAlCarrito(ProductoCercano prod) {
    CartService.instance.addItem(ItemCarrito(
      id: prod.id,
      nombre: prod.nombre,
      finca: prod.finca,
      unidad: prod.unidad,
      precioUnitario: prod.precio,
      cantidad: 1,
      imagenUrl: prod.imagenUrl,
    ));
    _mostrarSnack('${prod.nombre} agregado al carrito 🛒');
  }

  void _irATab(int index) {
    if (index == 0) return;
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExploradorProductos()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MisPedidosScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Profile()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      floatingActionButton: SupportFab(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.agrobotWelcome),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _encabezado(),
            Expanded(
              child: _cargando 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
              : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _buscador(),
                  const SizedBox(height: 16),
                  _categorias(),
                  const SizedBox(height: 24),
                  _tituloSeccion('Productos cerca de vos', conVerTodo: true),
                  const SizedBox(height: 12),
                  _scrollProductos(),
                  const SizedBox(height: 28),
                  if (_oferta != null) ...[
                    _tituloSeccion('Ofertas por excedente'),
                    const SizedBox(height: 12),
                    _OfertaCard(
                      oferta: _oferta!,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExploradorProductos(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  _tituloSeccion('Productores destacados'),
                  const SizedBox(height: 12),
                  ..._productores.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ProductorCard(
                        productor: p,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PerfilProductorScreen(productor: p),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        currentIndex: 0,
        onTap: _irATab,
      ),
    );
  }

  Widget _encabezado() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, María',
                  style: AppTextStyles.headline.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  'Encontrá productos frescos cerca de vos.',
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 13,
                    color: AppColors.bodyText,
                  ),
                ),
              ],
            ),
          ),
          _botonCircular(
            Icons.notifications_outlined,
            onTap: () => _mostrarSnack('No tienes notificaciones pendientes'),
          ),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: CartService.instance,
            builder: (context, _) => _botonCircular(
              Icons.shopping_cart_outlined,
              conBadge: CartService.instance.totalItems > 0,
              badgeCount: CartService.instance.totalItems,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonCircular(
    IconData icon, {
    bool conBadge = false,
    int badgeCount = 0,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () => _mostrarSnack(
            conBadge ? 'Carrito: $badgeCount producto(s)' : 'Notificaciones',
          ),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.tileBg,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(child: Icon(icon, size: 20, color: AppColors.titleDark)),
            if (conBadge && badgeCount > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.inputErrorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buscador() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BuscarProductos()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.inputBorderColor.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: AppColors.bodyText),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Buscar frutas, verduras y más',
                style: AppTextStyles.SubTitle.copyWith(
                  fontSize: 13,
                  color: AppColors.bodyText.withValues(alpha: 0.7),
                ),
              ),
            ),
            const Icon(Icons.tune, size: 18, color: AppColors.titleDark),
          ],
        ),
      ),
    );
  }

  Widget _categorias() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < _listaCategorias.length; i++)
          _CategoriaTile(
            categoria: _listaCategorias[i],
            seleccionada: i == _categoriaSel,
            onTap: () {
              setState(() => _categoriaSel = i);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExploradorProductos()),
              );
            },
          ),
      ],
    );
  }

  Widget _tituloSeccion(String texto, {bool conVerTodo = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            texto,
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 17),
          ),
        ),
        if (conVerTodo)
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExploradorProductos()),
            ),
            child: Text(
              'Ver todo',
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                color: AppColors.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _scrollProductos() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _cercanos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _ProductoCercanoCard(
          producto: _cercanos[i],
          onAdd: () => _agregarAlCarrito(_cercanos[i]),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PerfilProductorScreen()),
          ),
        ),
      ),
    );
  }
}

class _CategoriaTile extends StatelessWidget {
  final CategoriaMercado categoria;
  final bool seleccionada;
  final VoidCallback onTap;

  const _CategoriaTile({
    required this.categoria,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: seleccionada ? AppColors.blueSoft : categoria.bg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              categoria.icon,
              size: 26,
              color: seleccionada ? AppColors.accentBlue : categoria.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            categoria.label,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 12,
              color: AppColors.titleDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductoCercanoCard extends StatelessWidget {
  final ProductoCercano producto;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const _ProductoCercanoCard({
    required this.producto,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  producto.imagenUrl,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 110,
                    color: AppColors.tileBg,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 28,
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
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
                          size: 11,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 2),
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.finca,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'C\$ ${producto.precio.toStringAsFixed(2)}',
                            style: AppTextStyles.label.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            'por ${producto.unidad}',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onAdd,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.White,
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
      ),
    );
  }
}

class _OfertaCard extends StatelessWidget {
  final OfertaExcedente oferta;
  final VoidCallback onTap;

  const _OfertaCard({required this.oferta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.amberSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                oferta.imagenUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.amber.withValues(alpha: 0.2),
                  child: const Icon(Icons.percent, color: AppColors.amber),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.amber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${oferta.descuento}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          oferta.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.titleDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'C\$ ${oferta.precio.toStringAsFixed(2)}',
                        style: AppTextStyles.label.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'C\$ ${oferta.precioOriginal.toStringAsFixed(2)}',
                        style: AppTextStyles.SubTitle.copyWith(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  StatusChip(
                    label: oferta.vigencia,
                    background: AppColors.White,
                    color: AppColors.amber,
                    icon: Icons.timer_outlined,
                    radius: 16,
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

class _ProductorCard extends StatelessWidget {
  final ProductorDestacado productor;
  final VoidCallback onTap;

  const _ProductorCard({required this.productor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                productor.avatarUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  color: AppColors.tileBg,
                  child: const Icon(Icons.person, color: AppColors.bodyText),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          productor.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.titleDark,
                          ),
                        ),
                      ),
                      if (productor.verificado)
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: AppColors.accentBlue,
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.amber),
                      const SizedBox(width: 4),
                      Text(
                        productor.rating.toStringAsFixed(1),
                        style: AppTextStyles.label.copyWith(
                          fontSize: 13,
                          color: AppColors.titleDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${productor.ventas} ventas)',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.bodyText,
            ),
          ],
        ),
      ),
    );
  }
}
