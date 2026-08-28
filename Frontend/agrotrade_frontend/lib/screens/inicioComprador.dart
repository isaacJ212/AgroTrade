import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';


class CategoriaMercado {
  final String label;
  final IconData icon;
  final Color bg;
  final Color color;

  const CategoriaMercado(this.label, this.icon, this.bg, this.color);
}

class ProductoCercano {
  final String nombre;
  final String finca;
  final double precio;
  final String unidad;
  final String distancia;
  final String imagenUrl;

  const ProductoCercano({
    required this.nombre,
    required this.finca,
    required this.precio,
    required this.unidad,
    required this.distancia,
    required this.imagenUrl,
  });
}

class OfertaExcedente {
  final String nombre;
  final double precio;
  final double precioOriginal;
  final int descuento; 
  final String vigencia;
  final String imagenUrl;

  const OfertaExcedente({
    required this.nombre,
    required this.precio,
    required this.precioOriginal,
    required this.descuento,
    required this.vigencia,
    required this.imagenUrl,
  });
}

class ProductorDestacado {
  final String nombre;
  final double rating;
  final int ventas;
  final bool verificado;
  final String avatarUrl;

  const ProductorDestacado({
    required this.nombre,
    required this.rating,
    required this.ventas,
    required this.verificado,
    required this.avatarUrl,
  });
}

class InicioComprador extends StatefulWidget {
  const InicioComprador({super.key});

  @override
  State<InicioComprador> createState() => _InicioCompradorState();
}

class _InicioCompradorState extends State<InicioComprador> {

  int _categoriaSel = 1; 
  int _carritoCount = 1;

 
  static const List<CategoriaMercado> _categorias = [
    CategoriaMercado('Frutas', Icons.apple, AppColors.navPill, AppColors.primaryColor),
    CategoriaMercado('Cítricos', Icons.eco, AppColors.blueSoft, AppColors.accentBlue),
    CategoriaMercado('Verduras', Icons.grass, AppColors.navPill, AppColors.primaryColor),
    CategoriaMercado('Otros', Icons.category, AppColors.tileBg, AppColors.titleDark),
  ];

  static const List<ProductoCercano> _cercanos = [
    ProductoCercano(
      nombre: 'Tomate Chonto Fresco',
      finca: 'Finca La Esperanza',
      precio: 25.00,
      unidad: 'lb',
      distancia: '4.2 km',
      imagenUrl: 'https://images.unsplash.com/photo-1546094096-0df9bdcaaadd?auto=format&fit=crop&w=600&q=60',
    ),
    ProductoCercano(
      nombre: 'Naranja Valencia',
      finca: 'Coop. Los Andes',
      precio: 18.00,
      unidad: 'doc',
      distancia: '6.8 km',
      imagenUrl: 'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=600&q=60',
    ),
  ];

  static const OfertaExcedente _oferta = OfertaExcedente(
    nombre: 'Tomate (Granel)',
    precio: 21.25,
    precioOriginal: 25.00,
    descuento: 15,
    vigencia: 'Disponible hasta hoy',
    imagenUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcaea?auto=format&fit=crop&w=300&q=60',
  );

  static const List<ProductorDestacado> _productores = [
    ProductorDestacado(
      nombre: 'Cooperativa Los Andes',
      rating: 4.9,
      ventas: 120,
      verificado: true,
      avatarUrl: 'https://images.unsplash.com/photo-1595456272726-b3710772fa6f?auto=format&fit=crop&w=200&q=60',
    ),
    ProductorDestacado(
      nombre: 'Finca La Esperanza',
      rating: 4.7,
      ventas: 85,
      verificado: false,
      avatarUrl: 'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=200&q=60',
    ),
  ];

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }


  void _agregarAlCarrito(String producto) {
    setState(() => _carritoCount++);
    _mostrarSnack('$producto agregado al carrito 🛒');
  }

  void _irATab(int index) {
    if (index == 0) return;
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
            Expanded(
              child: ListView(
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
                  _tituloSeccion('Ofertas por excedente'),
                  const SizedBox(height: 12),
                  _OfertaCard(oferta: _oferta, onTap: () => _mostrarSnack('Detalle de oferta próximamente')),
                  const SizedBox(height: 28),
                  _tituloSeccion('Productores destacados'),
                  const SizedBox(height: 12),
                  ..._productores.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProductorCard(
                          productor: p,
                          onTap: () => _mostrarSnack('Perfil de ${p.nombre} próximamente'),
                        ),
                      )),
                ],
              ),
            ),
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
          _botonCircular(Icons.notifications_outlined),
          const SizedBox(width: 10),
          _botonCircular(Icons.shopping_cart_outlined, conBadge: true),
        ],
      ),
    );
  }


  Widget _botonCircular(IconData icon, {bool conBadge = false}) {
    return GestureDetector(
      onTap: () => _mostrarSnack(conBadge ? 'Carrito: $_carritoCount producto(s)' : 'Notificaciones'),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.tileBg,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(icon, size: 20, color: AppColors.titleDark),
            ),
            if (conBadge && _carritoCount > 0)
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
      onTap: () => _mostrarSnack('Buscador del mercado próximamente 🔎'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.inputBorderColor.withOpacity(0.5)),
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
                  color: AppColors.bodyText.withOpacity(0.7),
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
        for (int i = 0; i < _categorias.length; i++)
          _CategoriaTile(
            categoria: _categorias[i],
            seleccionada: i == _categoriaSel,
            onTap: () => setState(() => _categoriaSel = i),
          ),
      ],
    );
  }

.
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
            onTap: () => _mostrarSnack('Catálogo completo próximamente'),
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
          onAdd: () => _agregarAlCarrito(_cercanos[i].nombre),
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
            style: AppTextStyles.SubTitle.copyWith(fontSize: 12, color: AppColors.titleDark),
          ),
        ],
      ),
    );
  }
}


class _ProductoCercanoCard extends StatelessWidget {
  final ProductoCercano producto;
  final VoidCallback onAdd;

  const _ProductoCercanoCard({required this.producto, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: const Icon(Icons.image_not_supported_outlined,
                      size: 28, color: AppColors.bodyText),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.White.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.titleDark),
                      const SizedBox(width: 3),
                      Text(
                        producto.distancia,
                        style: AppTextStyles.chip.copyWith(color: AppColors.titleDark),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.titleDark),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.storefront_outlined, size: 14, color: AppColors.bodyText),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        producto.finca,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 8),
                Text(
                  'Precio x ${producto.unidad}',
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'C\$ ${producto.precio.toStringAsFixed(2)}',
                        style: AppTextStyles.statValue.copyWith(fontSize: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: AppColors.White, size: 18),
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
          color: AppColors.navPill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                oferta.imagenUrl,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 84,
                  height: 84,
                  color: AppColors.tileBg,
                  child: const Icon(Icons.image_not_supported_outlined,
                      size: 24, color: AppColors.bodyText),
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
                          oferta.nombre,
                          style: AppTextStyles.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.titleDark),
                        ),
                      ),
                      // ✅ REUSO StatusChip: "-15%"
                      StatusChip(
                        label: '-${oferta.descuento}%',
                        background: AppColors.chipGrey,
                        color: AppColors.errorColor,
                        radius: 8,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'C\$ ${oferta.precio.toStringAsFixed(2)}',
                        style: AppTextStyles.statValue.copyWith(fontSize: 16),
                      ),
                      Text(
                        '/lb',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(width: 6),
                    
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
                          style: AppTextStyles.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.titleDark),
                        ),
                      ),
                      if (productor.verificado)
                        const Icon(Icons.verified, size: 16, color: AppColors.accentBlue),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.amber),
                      const SizedBox(width: 4),
                      Text(
                        productor.rating.toStringAsFixed(1),
                        style: AppTextStyles.label.copyWith(fontSize: 13, color: AppColors.titleDark),
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
            const Icon(Icons.chevron_right, size: 20, color: AppColors.bodyText),
          ],
        ),
      ),
    );
  }
}