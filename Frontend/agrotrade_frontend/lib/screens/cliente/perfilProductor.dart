import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../ui/widgets/productor_widgets.dart' show ProductorImage;
import '../../ui/app_theme.dart';
import 'carrito.dart';
import 'exploradorProductos.dart';
import 'inicioComprador.dart';
import '../../models/Consumidor/consumidor_models.dart';
import '../../services/consumer_api_service.dart';
import '../../services/cart_service.dart';

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
  final ProductorDestacado productor;
  final bool soloLectura;
  final Uint8List? portadaBytes;
  final Widget? productosContenido;

  const PerfilProductorScreen({
    super.key,
    this.productor = fincaLaEsperanza,
    this.soloLectura = false,
    this.portadaBytes,
    this.productosContenido,
  });

  @override
  State<PerfilProductorScreen> createState() => _PerfilProductorScreenState();
}

class _PerfilProductorScreenState extends State<PerfilProductorScreen> {
  final Set<int> _carrito = {};
  
  List<ProductoMercado> _productos = [];
  bool _cargando = true;

  List<_Valoracion> _valoracionesLista = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    _cargarValoraciones();
  }

  Future<void> _cargarProductos() async {
    if (widget.productor.id != null) {
      final res = await ConsumerApiService.instance.getProductos(idProveedor: widget.productor.id);
      if (mounted) {
        setState(() {
          _productos = res.items;
          _cargando = false;
        });
      }
    } else {
      final todos = await ConsumerApiService.instance.getProductos();
      
      String normalizar(String nombre) => nombre
          .trim()
          .toLowerCase()
          .replaceFirst(RegExp(r'^coop\.\s*'), 'cooperativa ');

      final nombreProductor = normalizar(widget.productor.nombre);
      
      if (mounted) {
        setState(() {
          _productos = todos.items
            .where((producto) => normalizar(producto.finca) == nombreProductor)
            .toList(growable: false);
          _cargando = false;
        });
      }
    }
  }

  Future<void> _cargarValoraciones() async {
    if (widget.productor.id != null) {
      final valMap = await ConsumerApiService.instance.getValoraciones(widget.productor.id!);
      if (valMap.isNotEmpty) {
        if (mounted) {
          setState(() {
            _valoracionesLista = valMap.map((v) => _Valoracion(
              iniciales: (v['nombreCliente'] ?? 'C').toString().substring(0, 1).toUpperCase(),
              avatarColor: AppColors.primaryColor,
              nombre: v['nombreCliente'] ?? 'Cliente',
              rating: v['puntuacion']?.toDouble() ?? 5.0,
              comentario: v['comentario'] ?? '',
            )).toList();
          });
        }
        return;
      }
    }
    
    // Fallback
    if (mounted) {
      setState(() {
        _valoracionesLista = widget.productor.nombre == fincaLaEsperanza.nombre
            ? _valoracionesEsperanza
            : const [];
      });
    }
  }

  String get _heroUrl =>
      widget.productor.portadaUrl ?? widget.productor.avatarUrl;
  String get _avatarUrl => widget.productor.avatarUrl;

  List<_Valoracion> get _valoraciones => _valoracionesLista;

  static const List<_Valoracion> _valoracionesEsperanza = [
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

  void _toggleCarrito(ProductoMercado producto) {
    CartService.instance.addItem(ItemCarrito(
      id: producto.id,
      nombre: producto.nombre,
      finca: producto.finca,
      unidad: producto.unidad,
      precioUnitario: producto.precio,
      cantidad: 1,
      imagenUrl: producto.imagenUrl,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${producto.nombre} agregado al carrito 🛒'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
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
      bottomNavigationBar: !widget.soloLectura
          ? AnimatedBuilder(
              animation: CartService.instance,
              builder: (context, _) {
                if (CartService.instance.items.isEmpty) return const SizedBox.shrink();
                return Container(
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
                            'Ver Carrito (${CartService.instance.totalItems} items)',
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
                );
              },
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
      actions: widget.soloLectura ? [] : [
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
            if (widget.portadaBytes != null)
              Image.memory(widget.portadaBytes!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.primarySoftBg))
            else Image.network(
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
                width: 60,
                height: 60,
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
                  child: widget.portadaBytes != null
                    ? ProductorImage(bytes: widget.portadaBytes, height: 60, width: 60)
                    : Image.network(
                    _avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primarySoftBg,
                      child: const Icon(
                        Icons.agriculture_outlined,
                        size: 36,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (!widget.soloLectura) ElevatedButton.icon(
                onPressed: _enviarMensaje,
                icon: const Icon(Icons.chat_bubble_outline, size: 14),
                label: const Text(
                  'Enviar mensaje',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
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
          Text(
            widget.productor.nombre,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.agriculture_outlined,
                size: 15,
                color: AppColors.TextSoft,
              ),
              const SizedBox(width: 5),
              Text(
                widget.productor.tipo,
                style: const TextStyle(fontSize: 13, color: AppColors.TextSoft),
              ),
              if (widget.productor.verificado) ...[
                const SizedBox(width: 8),
                const Icon(Icons.verified, size: 15, color: AppColors.primaryColor),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.TextSoft,
              ),
              const SizedBox(width: 5),
              Text(
                widget.productor.ubicacion ?? 'Ubicación no registrada',
                style: const TextStyle(fontSize: 13, color: AppColors.TextSoft),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.amber),
              const SizedBox(width: 4),
              Text(
                widget.productor.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.productor.ventas} ventas',
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
          Text(
            widget.productor.tipo == 'Cooperativa'
                ? 'Sobre la cooperativa'
                : 'Sobre la finca',
            style: const TextStyle(
              fontSize: 16,
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
            child: Text(
              widget.productor.descripcion ?? 'Sin descripción disponible.',
              style: const TextStyle(
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
    if (widget.productosContenido != null) return widget.productosContenido!;
    final productos = _productos;
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
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_cargando)
            const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          else if (productos.isEmpty)
            const Text(
              'No hay productos registrados para esta finca.',
              style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
            )
          else GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              return _ProductoCard(
                producto: productos[index],
                inCarrito: false, // Could check CartService if wanted
                onToggle: () => _toggleCarrito(productos[index]),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: AppColors.amber),
                  const SizedBox(width: 4),
                  Text(
                    widget.productor.rating.toStringAsFixed(1),
                    style: const TextStyle(
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
          if (_valoraciones.isEmpty)
            const Text(
              'No hay reseñas disponibles para mostrar.',
              style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
            )
          else
            ..._valoraciones.map((v) => _ValoracionTile(valoracion: v)),
        ],
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final ProductoMercado producto;
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
