import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'entrega.dart';
import 'exploradorProductos.dart';
import 'inicioComprador.dart';

class _ItemCarrito {
  final int id;
  final String nombre;
  final String finca;
  final String unidad;
  final double precioUnitario;
  int cantidad;
  final String imagenUrl;

  _ItemCarrito({
    required this.id,
    required this.nombre,
    required this.finca,
    required this.unidad,
    required this.precioUnitario,
    required this.cantidad,
    required this.imagenUrl,
  });

  double get subtotal => precioUnitario * cantidad;
}

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  late List<_ItemCarrito> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _ItemCarrito(
        id: 1,
        nombre: 'Tomate',
        finca: 'Finca La Esperanza',
        unidad: 'lb',
        precioUnitario: 25.00,
        cantidad: 2,
        imagenUrl:
            'https://images.unsplash.com/photo-1546094096-0df9bdcaaadd?auto=format&fit=crop&w=200&q=60',
      ),
      _ItemCarrito(
        id: 2,
        nombre: 'Limón',
        finca: 'Finca La Esperanza',
        unidad: 'lb',
        precioUnitario: 20.00,
        cantidad: 1,
        imagenUrl:
            'https://images.unsplash.com/photo-1590502591965-156b8b3f0e53?auto=format&fit=crop&w=200&q=60',
      ),
      _ItemCarrito(
        id: 3,
        nombre: 'Naranja',
        finca: 'Cooperativa Los Andes',
        unidad: 'doc',
        precioUnitario: 18.00,
        cantidad: 2,
        imagenUrl:
            'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=200&q=60',
      ),
    ];
  }

  Map<String, List<_ItemCarrito>> get _agrupadoPorFinca {
    final Map<String, List<_ItemCarrito>> map = {};
    for (final item in _items) {
      map.putIfAbsent(item.finca, () => []).add(item);
    }
    return map;
  }

  double get _subtotalProductos =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void _cambiarCantidad(int id, int delta) {
    setState(() {
      final item = _items.firstWhere((i) => i.id == id);
      final nuevaCantidad = item.cantidad + delta;
      if (nuevaCantidad <= 0) {
        _items.removeWhere((i) => i.id == id);
      } else {
        item.cantidad = nuevaCantidad;
      }
    });
  }

  void _eliminarItem(int id) {
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  void _continuarEntrega() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EntregaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return _buildCarritoVacio(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerInfo(),
                  const SizedBox(height: 20),
                  ..._buildGruposProductor(),
                  const SizedBox(height: 8),
                  _buildResumen(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
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
      title: const Text(
        'Carrito',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBannerInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.info_outline_rounded,
            size: 17,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tu pedido se organizará por productor para facilitar la preparación y entrega.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primarySoft,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGruposProductor() {
    final grupos = _agrupadoPorFinca;
    return grupos.entries.map((entry) {
      final finca = entry.key;
      final items = entry.value;
      final subtotalFinca = items.fold(0.0, (s, i) => s + i.subtotal);

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: const BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.agriculture_outlined,
                      size: 17,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      finca,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.titleDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...items.map(
              (item) => _ItemTile(
                item: item,
                onIncrement: () => _cambiarCantidad(item.id, 1),
                onDecrement: () => _cambiarCantidad(item.id, -1),
                onDelete: () => _eliminarItem(item.id),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                children: [
                  Text(
                    'Subtotal $finca',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.TextSoft,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'C\$${subtotalFinca.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildResumen() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _ResumenRow(
            label: 'Subtotal productos',
            valor: 'C\$${_subtotalProductos.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          const _ResumenRow(
            label: 'Entrega',
            valor: 'Se calculará en el siguiente paso',
            valorColor: AppColors.TextSoft,
            labelBold: false,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          Row(
            children: [
              const Text(
                'Total parcial:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
              const Spacer(),
              Text(
                'C\$${_subtotalProductos.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE4E7E5), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: 'Continuar con la entrega',
              radius: 100,
              onPressed: _continuarEntrega,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Seguir comprando',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarritoVacio(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
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
        title: const Text(
          'Carrito',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoftBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 48,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tu carrito está vacío',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explora los productos disponibles y agrega los que deseas a tu carrito.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.TextSoft,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Explorar productos',
                radius: 100,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploradorProductos()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final _ItemCarrito item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const _ItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.errorBg,
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.errorDark,
          size: 24,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Image.network(
                  item.imagenUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primarySoftBg,
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nombre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${item.cantidad} ${item.unidad} x C\$${item.precioUnitario.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.TextSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'C\$${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _StepButton(
                      icon: Icons.remove,
                      onTap: onDecrement,
                      isDanger: item.cantidad == 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.cantidad}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.titleDark,
                        ),
                      ),
                    ),
                    _StepButton(icon: Icons.add, onTap: onIncrement),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDanger;

  const _StepButton({
    required this.icon,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDanger ? AppColors.errorBg : AppColors.primarySoftBg,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDanger ? AppColors.errorDark : AppColors.primaryColor,
        ),
      ),
    );
  }
}

class _ResumenRow extends StatelessWidget {
  final String label;
  final String valor;
  final Color? valorColor;
  final bool labelBold;

  const _ResumenRow({
    required this.label,
    required this.valor,
    this.valorColor,
    this.labelBold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: labelBold ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.TextSoft,
          ),
        ),
        const Spacer(),
        Text(
          valor,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valorColor ?? AppColors.titleDark,
          ),
        ),
      ],
    );
  }
}
