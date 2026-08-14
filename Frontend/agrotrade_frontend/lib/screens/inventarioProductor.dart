import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';
import 'inicioProductor.dart';
import 'detalleProducto.dart';

enum EstadoProducto{

  disponible,
  pocoInventario,
  agotado;


  String get label => switch (this){
    EstadoProducto.disponible => 'Disponible',
    EstadoProducto.pocoInventario => 'Poco Inventario',
    EstadoProducto.agotado => 'Agotado',
  };

  IconData get icon => switch (this){
    EstadoProducto.disponible => Icons.check_circle,
    EstadoProducto.pocoInventario => Icons.warning_amber,
    EstadoProducto.agotado => Icons.block,
  };

  Color get chipBg => switch (this) {
    EstadoProducto.disponible => AppColors.navPill,
    EstadoProducto.pocoInventario => AppColors.errorBg,
    EstadoProducto.agotado => AppColors.tileBg,
  };

  Color get chipText => switch (this) {
    EstadoProducto.disponible => AppColors.primaryColor,
    EstadoProducto.pocoInventario => AppColors.errorDark,
    EstadoProducto.agotado => AppColors.bodyText,
  };
  
}


class Producto{
  final int id;
  final String nombre;
  final double cantidad;
  final String unidad;
  final double precio;
  final String sufijoPrecio;
  final String? cosecha;
  final EstadoProducto estado;
  final String imagenUrl;
  //
  final String etiqueta;
  final String? ubicacion;
  final String? descripcion;
  final List<Costo> costos;

  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    required this.precio,
    required this.estado,
    required this.imagenUrl,
    this.sufijoPrecio = '',
    this.cosecha,
    //
    this.etiqueta = 'Fresco',   
    this.ubicacion,             
    this.descripcion,           
    this.costos = const [], 

  });

  String get cantidadTexto => '${cantidad.toStringAsFixed(0)} $unidad';
  String get precioTexto => '\$${precio.toStringAsFixed(2)}$sufijoPrecio';

}

//clase ara el desgloce de los cstes
class Costo{
  final String concepto;
  final String monto;

  const Costo({
    required this.concepto,
    required this.monto,
  });
}

class InventarioProductor extends StatefulWidget {
  const InventarioProductor({super.key});

  @override
  State<InventarioProductor> createState() => _InventarioProductorState();
}

class _InventarioProductorState extends State<InventarioProductor> {
  String _busqueda = '';
  EstadoProducto? _filtroActual; 


  static const List<Producto> _productos = [
    Producto(
      id: 1,
      nombre: 'Tomate Híbrido Saladette',
      cantidad: 1200,
      unidad: 'kg',
      precio: 18.50,
      cosecha: '15 Oct 2023',
      estado: EstadoProducto.disponible,
      imagenUrl:
        'https://images.unsplash.com/photo-1546094096-0df9bdcaaadd?auto=format&fit=crop&w=900&q=60',
      etiqueta: 'Fresco',
      ubicacion: "Finca 'El Sol', Sinaloa, MX",
      descripcion:
        'Tomate saladette de primera calidad, cultivado bajo invernadero con sistema de riego por goteo para optimizar recursos hídricos. Calibre uniforme, ideal para mercado fresco o procesamiento. Libre de pesticidas restringidos.',
      costos: const [
        Costo(concepto: 'Costo Producción', monto: '\$12.00/kg'),
        Costo(concepto: 'Empaque', monto: '\$2.50/kg'),
        Costo(concepto: 'Margen', monto: '\$4.00/kg'),
        ],
    ),

    Producto(
      id: 2,
      nombre: 'Aguacate Hass Exportación',
      cantidad: 12,
      unidad: 'Cajas',
      precio: 45.00,
      cosecha: '10 Oct 2023',
      estado: EstadoProducto.pocoInventario,
      imagenUrl:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=900&q=60',
    ),
    Producto(
      id: 3,
      nombre: 'Maíz Amarillo Granel',
      cantidad: 0,
      unidad: 'Toneladas',
      precio: 320.00,
      sufijoPrecio: ' / Ton',
      estado: EstadoProducto.agotado,
      imagenUrl:
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=900&q=60',
    ),
  ];

  static const List<NavElemento> _navItems = [
    NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
    NavElemento(label: 'Explorar', icon: Icons.explore_outlined, activeIcon: Icons.explore),
    NavElemento(label: 'Inventario', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
    NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
  ];


  List<Producto> get _filtrados => _productos.where((p) {
        final porEstado = _filtroActual == null || p.estado == _filtroActual;
        final texto = _busqueda.trim().toLowerCase();
        final porTexto =
            texto.isEmpty || p.nombre.toLowerCase().contains(texto);
        return porEstado && porTexto;
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

  void _irATab(int index) {
    if (index == 2) return; // ya estamos en Inventario
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _barraSuperior(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gestión de Inventario', style: AppTextStyles.headline),
                  const SizedBox(height: 8),
                  Text(
                    'Administra tus productos, cantidades y precios.',
                    style: AppTextStyles.SubTitle.copyWith(
                      fontSize: 15,
                      color: AppColors.bodyText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buscador(),
            const SizedBox(height: 8),
            _tabsFiltro(),
            const Divider(height: 1, color: AppColors.cardBorder),
            
            Expanded(child: _lista()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SupportFab(
          icono: Icons.add,
          onPressed: () => _mostrarSnack('Formulario de nuevo producto próximamente 🌱'),
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: _navItems,
        currentIndex: 2,
        onTap: _irATab,
      ),
    );
  }

 
  Widget _barraSuperior() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('AgroTrade', style: AppTextStyles.wordmark),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.titleDark),
                onPressed: () => _mostrarSnack('Sin notificaciones nuevas'),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle_outlined,
                    color: AppColors.primaryColor, size: 28),
                onPressed: () => _mostrarSnack('Perfil próximamente'),
              ),
            ],
          ),
        ],
      ),
    );
    
  }

 
  Widget _buscador() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: TextField(

          onChanged: (valor) => setState(() => _busqueda = valor),
          decoration: InputDecoration(
            hintText: 'Buscar por nombre, categoría o ID...',
            hintStyle: AppTextStyles.cardTitle.copyWith(
              color: AppColors.bodyText.withOpacity(0.5),
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.bodyText),
            border: InputBorder.none, // 📚 quitamos el borde default;
            // el borde lo pone el Container exterior
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

 
  Widget _tabsFiltro() {
    
    final filtros = <EstadoProducto?>[null, ...EstadoProducto.values];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, 
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (final filtro in filtros) _tabFiltro(filtro),
        ],
      ),
    );
  }

  Widget _tabFiltro(EstadoProducto? filtro) {
    final activo = _filtroActual == filtro;
    return GestureDetector(
      onTap: () => setState(() => _filtroActual = filtro),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              filtro?.label ?? 'Todos', // 📚 operador ?. y ?? juntos
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: activo ? AppColors.primarySoft : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 10),
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
            Icon(Icons.search_off, size: 48, color: AppColors.bodyText),
            const SizedBox(height: 8),
            Text('No se encontraron productos',
                style: AppTextStyles.cardTitle),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      itemCount: productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, i) => _ProductoCard(
        producto: productos[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProducto(producto: productos[i]),
          ),
        ),
        onAccion: () => _mostrarSnack('Disponible al conectar el backend 🌱'),
      ),
    );
  }
}


class _ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onAccion;
  final VoidCallback? onTap;

  const _ProductoCard({
    required this.producto, 
    required this.onAccion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final agotado = producto.estado == EstadoProducto.agotado;
    final colorBase = agotado ? AppColors.bodyText : AppColors.titleDark;
    final colorCantidad = producto.estado == EstadoProducto.pocoInventario
        ? AppColors.errorColor
        : colorBase;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        clipBehavior: Clip.antiAlias, 
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
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
              _imagen(),
              Positioned(
                top: 12,
                left: 12,
                child: StatusChip(
                  label: producto.estado.label,
                  background: producto.estado.chipBg,
                  color: producto.estado.chipText,
                  icon: producto.estado.icon,
                  radius: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: AppTextStyles.productoTitle.copyWith(color: colorBase),
                ),
                const SizedBox(height: 12),
                InfoRow(
                    label: 'Cantidad:',
                    value: producto.cantidadTexto,
                    valueColor: colorCantidad),
                const SizedBox(height: 8),
                InfoRow(
                    label: 'Precio unitario:',
                    value: producto.precioTexto,
                    valueColor:
                        agotado ? AppColors.bodyText : AppColors.primaryColor),
                const SizedBox(height: 8),
                InfoRow(
                    label: 'Cosecha:',
                    value: producto.cosecha ?? '-',
                    valueColor: colorBase),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: NeutralButton(
              label: agotado ? 'Actualizar Stock' : 'Editar',
              textColor: agotado ? AppColors.bodyText : AppColors.titleDark,
              onPressed: onAccion,
            ),
          ),
        ],
      ),
    ));
  }

 
  Widget _imagen() {
    return Image.network(
      producto.imagenUrl,
      height: 190,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return SizedBox(
          height: 190,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 190,
          width: double.infinity,
          color: AppColors.tileBg,
          child: Icon(Icons.image_not_supported_outlined,
              size: 40, color: AppColors.bodyText),
        );
      },
    );
  }
}