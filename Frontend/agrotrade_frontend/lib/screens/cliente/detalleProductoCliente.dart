import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../shared/chat/chatMensajes.dart';
import 'carrito.dart';
import 'exploradorProductos.dart' show ProductoMercado;
import 'perfilProductor.dart';

class DetalleProductoCliente extends StatefulWidget {
  final ProductoMercado producto;

  const DetalleProductoCliente({super.key, required this.producto});

  @override
  State<DetalleProductoCliente> createState() => _DetalleProductoClienteState();
}

class _DetalleProductoClienteState extends State<DetalleProductoCliente> {
  int _cantidad = 2;

  String _unidadTexto({bool plural = false}) {
    switch (widget.producto.unidad.toLowerCase()) {
      case 'lb':
      case 'libra':
      case 'libras':
        return plural ? 'libras' : 'libra';
      case 'kg':
        return plural ? 'kilogramos' : 'kilogramo';
      case 'doc':
      case 'docena':
      case 'docenas':
        return plural ? 'docenas' : 'docena';
      default:
        return widget.producto.unidad;
    }
  }

  void _incrementar() {
    setState(() => _cantidad++);
  }

  void _decrementar() {
    if (_cantidad > 1) {
      setState(() => _cantidad--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.titleDark),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agregado a favoritos'),
                  backgroundColor: AppColors.primaryColor,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.titleDark,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarritoScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCDCDC),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(producto.imagenUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (producto.cosechadoHoy)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.spa, color: AppColors.White, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Cosechado hoy',
                            style: TextStyle(
                              color: AppColors.White,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.categoria.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.TextSoft,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Finca
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          producto.finca,
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      if (producto.calificacion != null) ...[
                        Text(
                          producto.calificacion!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.TextMain,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '·',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.TextSoft,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        producto.valoraciones == null
                            ? 'Sin valoraciones'
                            : '${producto.valoraciones} valoraciones',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.TextSoft,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '·',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.TextSoft,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'A ${producto.distancia}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.TextSoft,
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 1, color: AppColors.cardBorder),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'C\$ ${producto.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            'por ${_unidadTexto()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.TextSoft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            producto.pocoInventario
                                ? 'Poco inventario'
                                : 'Disponible',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    producto.descripcion ?? 'Sin descripción disponible.',
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.TextSoft,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PerfilProductorScreen(),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver perfil del productor',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cantidad',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.TextMain,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.screenBg,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: AppColors.primaryColor,
                                    onPressed: _decrementar,
                                  ),
                                  Container(
                                    width: 30,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_cantidad',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.TextMain,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    color: AppColors.primaryColor,
                                    onPressed: _incrementar,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _unidadTexto(plural: _cantidad != 1),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.TextSoft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySoftBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_shipping_outlined,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrega disponible',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.TextMain,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Calculado en el checkout',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.TextSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: AppColors.White,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatMensajes(
                      contactName: producto.finca,
                      contactRole: "Productor",
                    ),
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Enviar mensaje'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto agregado al carrito 🛒'),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarritoScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                label: const Text('Agregar al carrito'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.White,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
