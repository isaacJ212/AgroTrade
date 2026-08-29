import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'carrito.dart';
import 'inicioComprador.dart';

class _ProductoProductor {
  final String nombre;
  final String unidad;
  final double precio;
  final String imagenUrl;

  const _ProductoProductor({
    required this.nombre,
    required this.unidad,
    required this.precio,
    required this.imagenUrl,
  });
}

class _Valoracion {
  final String iniciales;
  final Color avatarColor;
  final String nombre;
  final double rating;
  final String comentario;

  const _Valoracion({
    required this.iniciales,
    required this.avatarColor,
    required this.nombre,
    required this.rating,
    required this.comentario,
  });
}

class PerfilProductorScreen extends StatefulWidget {
  const PerfilProductorScreen({super.key});

  @override
  State<PerfilProductorScreen> createState() => _PerfilProductorScreenState();
}

class _PerfilProductorScreenState extends State<PerfilProductorScreen> {
  final Set<int> _carrito = {};

  static const String _heroUrl =
      'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1200&q=80';
  static const String _avatarUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80';

  static const List<_ProductoProductor> _productos = [
    _ProductoProductor(
      nombre: 'Tomate Manzano',
      unidad: 'Caja 20kg',
      precio: 15.00,
      imagenUrl:
          'https://images.unsplash.com/photo-1546094096-0df9bdcaaadd?auto=format&fit=crop&w=400&q=70',
    ),
    _ProductoProductor(
      nombre: 'Naranja Valencia',
      unidad: 'Saco 50kg',
      precio: 22.50,
      imagenUrl:
          'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=400&q=70',
    ),
    _ProductoProductor(
      nombre: 'Limón Persa',
      unidad: 'Caja 15kg',
      precio: 18.00,
      imagenUrl:
          'https://images.unsplash.com/photo-1590502591965-156b8b3f0e53?auto=format&fit=crop&w=400&q=70',
    ),
    _ProductoProductor(
      nombre: 'Chiltoma Roja',
      unidad: 'lb',
      precio: 9.50,
      imagenUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&w=400&q=70',
    ),
  ];

  static const List<_Valoracion> _valoraciones = [
    _Valoracion(
      iniciales: 'ML',
      avatarColor: AppColors.primaryColor,
      nombre: 'María López',
      rating: 5.0,
      comentario:
          'Excelente calidad y frescura en los tomates. Llegaron en perfecto estado y muy puntuales.',
    ),
    _Valoracion(
      iniciales: 'JR',
      avatarColor: AppColors.accentBlue,
      nombre: 'Juan Rodríguez',
      rating: 4.5,
      comentario:
          'Muy buena atención del productor. Los cítricos tenían un sabor increíble.',
    ),
  ];

  void _toggleCarrito(int index) {
    setState(() {
      if (_carrito.contains(index)) {
        _carrito.remove(index);
      } else {
        _carrito.add(index);
      }
    });
  }

  void _enviarMensaje() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Abriendo chat con el productor…'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _compartir() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Enlace copiado al portapapeles 📋'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(height: 1, color: Color(0xFFE4E7E5)),
                _buildSobreLaFinca(),
                const Divider(height: 1, color: Color(0xFFE4E7E5)),
                _buildProductosDisponibles(),
                const Divider(height: 1, color: Color(0xFFE4E7E5)),
                _buildValoraciones(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _carrito.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE4E7E5), width: 1)),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarritoScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Ver Carrito (${_carrito.length} seleccionados)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
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
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: _compartir,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarritoScreen()),
            ),
          ),
        ),
      ],
      title: const Text(
        'Perfil del Productor',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _heroUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.primarySoftBg),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x88000000)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    _avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primarySoftBg,
                      child: const Icon(
                        Icons.person,
                        size: 36,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _enviarMensaje,
                icon: const Icon(Icons.chat_bubble_outline, size: 16),
                label: const Text(
                  'Enviar mensaje',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Carlos Martínez',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(
                Icons.agriculture_outlined,
                size: 15,
                color: AppColors.TextSoft,
              ),
              SizedBox(width: 5),
              Text(
                'Finca La Esperanza',
                style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.TextSoft,
              ),
              SizedBox(width: 5),
              Text(
                'Jinotepe, Carazo',
                style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.star_rounded, size: 18, color: AppColors.amber),
              SizedBox(width: 4),
              Text(
                '4.8',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '32 valoraciones',
                style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSobreLaFinca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sobre la finca',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Text(
              'Dedicados a la producción agrícola sostenible '
              'desde hace más de 20 años. En Finca La Esperanza, '
              'cultivamos nuestras tierras respetando los ciclos '
              'naturales y utilizando prácticas amigables con el '
              'medio ambiente para ofrecer los productos más '
              'frescos de la región.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.TextSoft,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductosDisponibles() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Productos disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _productos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              return _ProductoCard(
                producto: _productos[index],
                inCarrito: _carrito.contains(index),
                onToggle: () => _toggleCarrito(index),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildValoraciones() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Valoraciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const Spacer(),
              Row(
                children: const [
                  Icon(Icons.star_rounded, size: 18, color: AppColors.amber),
                  SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._valoraciones.map((v) => _ValoracionTile(valoracion: v)),
        ],
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final _ProductoProductor producto;
  final bool inCarrito;
  final VoidCallback onToggle;

  const _ProductoCard({
    required this.producto,
    required this.inCarrito,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: inCarrito ? AppColors.primaryColor : AppColors.cardBorder,
          width: inCarrito ? 1.5 : 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              producto.imagenUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.primarySoftBg),
            ),
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  producto.unidad,
                  style: const TextStyle(fontSize: 11, color: AppColors.TextSoft),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'C\$${producto.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onToggle,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: inCarrito
                              ? AppColors.primaryColor
                              : AppColors.primarySoftBg,
                        ),
                        child: Icon(
                          inCarrito ? Icons.check : Icons.add,
                          size: 16,
                          color: inCarrito
                              ? Colors.white
                              : AppColors.primaryColor,
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

class _ValoracionTile extends StatelessWidget {
  final _Valoracion valoracion;

  const _ValoracionTile({required this.valoracion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: valoracion.avatarColor,
                child: Text(
                  valoracion.iniciales,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  valoracion.nombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  final double r = valoracion.rating;
                  return Icon(
                    i < r ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 16,
                    color: AppColors.amber,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            valoracion.comentario,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.TextSoft,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
