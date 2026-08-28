import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

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
      iniciales: 'M',
      avatarColor: Color(0xFF006E2C),
      nombre: 'María G.',
      rating: 5,
      comentario:
          '"Excelente calidad de los tomates. Llegaron en perfecto estado y muy puntales."',
    ),
    _Valoracion(
      iniciales: 'J',
      avatarColor: Color(0xFF1565C0),
      nombre: 'Juan P.',
      rating: 4,
      comentario: '"Productos muy frescos. Volveré a comprar seguro."',
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
        content: const Text('Compartir perfil (próximamente)'),
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
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
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
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
      ],
      title: const Text(
        'Productor',
        style: TextStyle(
          color: AppColors.primaryColor,
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
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.18),
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
              // Botón Enviar mensaje
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
          // Nombre
          const Text(
            'Carlos Martínez',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 6),
          // Finca
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
          // Ubicación
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
          // Rating
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.amber),
              const SizedBox(width: 4),
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '32 valoraciones',
                style: const TextStyle(fontSize: 13, color: AppColors.TextSoft),
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
            children: [
              const Text(
                'Productos disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
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
          const Text(
            'Valoraciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 14),
          ..._valoraciones.map((v) => _ValoracionTile(valoracion: v)).toList(),
          const SizedBox(height: 16),
          // Botón ver todas
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.titleDark,
                side: const BorderSide(color: AppColors.cardBorder, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Ver todas las valoraciones',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleDark,
                ),
              ),
            ),
          ),
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
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.network(
                producto.imagenUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primarySoftBg,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 36,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.TextSoft,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                    // Botón agregar / quitar
                    GestureDetector(
                      onTap: onToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: inCarrito
                              ? AppColors.primaryColor
                              : AppColors.primarySoftBg,
                          shape: BoxShape.circle,
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
              // Avatar inicial
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
              // Estrellas
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
