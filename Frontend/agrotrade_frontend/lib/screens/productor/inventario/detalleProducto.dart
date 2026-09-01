import 'package:flutter/material.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../precio_justo/calculadoraPrecioJusto.dart';
import '../inicioProductor.dart';
import 'inventarioProductor.dart';     


class DetalleProducto extends StatefulWidget {
  final Producto producto;

  const DetalleProducto({super.key, required this.producto});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  Producto get _producto => widget.producto;


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

  // navegación de la barra inferior.
  void _irATab(int index) {
    if (index == 2) return; // seguimos en el mundo "Inventario"
    if (index == 0) {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioProductor()),
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _heroImagen(),
                  const SizedBox(height: 20),
                  _tituloYCompartir(),
                  const SizedBox(height: 8),
                  _ubicacion(),
                  const SizedBox(height: 16),
                  _precio(),
                  const SizedBox(height: 24),
                  _tarjetaPrecioJusto(),
                  const SizedBox(height: 16),
                  _tilesDatos(),

                  if (_producto.descripcion != null) ...[
                    const SizedBox(height: 28),
                    _descripcion(),
                  ],


                  if (_producto.costos.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _DesgloseCostos(
                      costos: _producto.costos,
                      total:
                          '${_producto.precioTexto} / ${_producto.unidad}',
                    ),
                  ],

                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Editar producto',
                    icon: Icons.edit_outlined,
                    radius: 26, 
                    onPressed: () => Navigator.pushNamed(context, '/productor/inventario/agregar'),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Actualizar inventario',
                    icon: Icons.update,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/productor/inventario/agregar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
          NavElemento(label: 'Explorar', icon: Icons.explore_outlined, activeIcon: Icons.explore),
          NavElemento(label: 'Inventario', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: 2,
        onTap: _irATab,
      ),
    );
  }


  Widget _encabezado() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            'Detalle de Producto',
            style: AppTextStyles.headline.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


  Widget _heroImagen() {

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.network(
            _producto.imagenUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover, // 📚 cubre el área sin deformar
            loadingBuilder: (context, child, progreso) {
              if (progreso == null) return child;
              return SizedBox(
                height: 300,
                child: const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 300,
                width: double.infinity,
                color: AppColors.tileBg,
                child: const Icon(Icons.image_not_supported_outlined,
                    size: 40, color: AppColors.bodyText),
              );
            },
          ),
          Positioned(
            top: 12,
            left: 12,
            child: StatusChip(
              label: _producto.etiqueta,
              background: AppColors.navPill,
              color: AppColors.primaryColor,
              icon: Icons.eco,
              radius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tituloYCompartir() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Text(_producto.nombre, style: AppTextStyles.headline),
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.accentBlue),
          onPressed: () => _mostrarOpcionesCompartir(context),
        ),
      ],
    );
  }


  Widget _ubicacion() {

    final ubicacion = _producto.ubicacion ?? 'Ubicación no disponible';
    return Row(
      children: [
        const Icon(Icons.location_on_outlined,
            size: 18, color: AppColors.bodyText),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            ubicacion,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 15,
              color: AppColors.bodyText,
            ),
          ),
        ),
      ],
    );
  }


  Widget _precio() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(_producto.precioTexto, style: AppTextStyles.price),
        const SizedBox(width: 6),

        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '/ ${_producto.unidad}',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }


  Widget _tarjetaPrecioJusto() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.amberSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_outlined,
                color: AppColors.amber, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precio Justo Verificado',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Este productor cumple con los estándares de comercio justo agrícola.',
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 14,
                    color: AppColors.bodyText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CalculadoraPrecioJusto(nombreProducto: _producto.nombre),
              ),
            ),
            child: Text(
              'Calcular precio justo',
              style: AppTextStyles.label.copyWith(
                color: AppColors.accentBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _tilesDatos() {
    return Row(
      children: [
        Expanded(
          child: _TileDato(
            icon: Icons.inventory_2_outlined,
            label: 'Existencia',
            valor: _producto.cantidadTexto,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _TileDato(
            icon: Icons.calendar_month_outlined,
            label: 'Fecha de Cosecha',
            valor: _producto.cosecha ?? '-',
          ),
        ),
      ],
    );
  }

  /// Sección de descripción.
  Widget _descripcion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripción', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        Text(
          _producto.descripcion!, 
          style: AppTextStyles.SubTitle.copyWith(
            fontSize: 15,
            color: AppColors.bodyText,
            height: 1.6, 
          ),
        ),
      ],
    );
  }

  void _mostrarOpcionesCompartir(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: AppColors.primaryColor),
                title: const Text('Copiar enlace', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enlace copiado al portapapeles')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.primaryColor),
                title: const Text('Compartir vía WhatsApp', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}


class _TileDato extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _TileDato({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tileBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.bodyText, size: 22),
          const SizedBox(height: 10),
          Text(label, style: AppTextStyles.cardTitle),
          const SizedBox(height: 4),
          Text(
            valor,
            style: AppTextStyles.productoTitle.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class _DesgloseCostos extends StatefulWidget {
  final List<Costo> costos;
  final String total;

  const _DesgloseCostos({required this.costos, required this.total});

  @override
  State<_DesgloseCostos> createState() => _DesgloseCostosState();
}

class _DesgloseCostosState extends State<_DesgloseCostos> {

  bool _abierto = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // ---- Header táctil ----
          InkWell(

            onTap: () => setState(() => _abierto = !_abierto),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.payments_outlined,
                      color: AppColors.primaryColor, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Desglose de Costos',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.titleDark,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _abierto ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.expand_more,
                        color: AppColors.bodyText),
                  ),
                ],
              ),
            ),
          ),

          // este es la parte desplegable 

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter, // 📚 crece hacia abajo
            child: _abierto
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        // 📚 collection-for: una fila por cada Costo.
                        for (final costo in widget.costos) ...[
                          const SizedBox(height: 8),
                          InfoRow(
                            label: costo.concepto,
                            value: costo.monto,
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        const SizedBox(height: 12),
                        // Total en negrita a ambos lados.
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Venta',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.titleDark,
                              ),
                            ),
                            Text(
                              widget.total,
                              style: AppTextStyles.label.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.titleDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
           
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}