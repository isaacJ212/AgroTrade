import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'pago.dart';
import 'pedidoConfirmado.dart';
import '../../services/cart_service.dart';
import '../../services/consumer_api_service.dart';

class _LineaProducto {
  final String nombre;
  final String cantidad;
  final double precio;

  const _LineaProducto({
    required this.nombre,
    required this.cantidad,
    required this.precio,
  });
}



class ResumenConfirmacionScreen extends StatefulWidget {
  const ResumenConfirmacionScreen({super.key});

  @override
  State<ResumenConfirmacionScreen> createState() => _ResumenConfirmacionScreenState();
}

class _ResumenConfirmacionScreenState extends State<ResumenConfirmacionScreen> {
  static const double _costoEntrega = 40.00;
  double get _subtotalProductos => CartService.instance.subtotalProductos;
  double get _total => _subtotalProductos + _costoEntrega;
  
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildStepper(),
          const Divider(height: 1, color: Color(0xFFE4E7E5)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _SectionHeader(
                    icon: Icons.shopping_basket_outlined,
                    label: 'Productos',
                  ),
                  const SizedBox(height: 12),
                  _buildProductosCard(),

                  const SizedBox(height: 20),

                  _SectionHeader(
                    icon: Icons.local_shipping_outlined,
                    label: 'Entrega',
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    children: const [
                      _FilaInfo(
                        valor: 'Entrega a domicilio',
                        icon: Icons.home_outlined,
                      ),
                      SizedBox(height: 6),
                      _FilaInfo(
                        valor: 'Jinotepe, Carazo',
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _SectionHeader(
                    icon: Icons.credit_card_outlined,
                    label: 'Pago',
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    children: const [_FilaInfoVisa(valor: 'Terminada en 4242')],
                  ),

                  const SizedBox(height: 20),

                  _SectionHeader(
                    icon: Icons.receipt_long_outlined,
                    label: 'Resumen',
                  ),
                  const SizedBox(height: 12),
                  _buildResumen(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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
              MaterialPageRoute(builder: (_) => const PagoScreen()),
            );
          }
        },
      ),
      title: const Text(
        'Confirmar pedido',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.titleDark,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStepper() {
    const steps = [
      (Icons.shopping_cart_outlined, 'Carrito'),
      (Icons.local_shipping_outlined, 'Entrega'),
      (Icons.check_rounded, 'Confirmación'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(height: 2, color: AppColors.primaryColor),
            );
          }
          final idx = i ~/ 2;
          final (icon, label) = steps[idx];
          final bool isLast = idx == steps.length - 1;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isLast ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProductosCard() {
    final grupos = CartService.instance.agrupadoPorFinca;

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
          ...grupos.entries.expand(
            (grupo) => [

              Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                decoration: const BoxDecoration(
                  color: AppColors.scaffoldBg,
                  border: Border(
                    bottom: BorderSide(color: AppColors.cardBorder),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.agriculture_outlined,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      grupo.key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.titleDark,
                      ),
                    ),
                  ],
                ),
              ),

              ...grupo.value.map(
                (p) => Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.nombre,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.titleDark,
                              ),
                            ),
                            Text(
                              '${p.cantidad} ${p.unidad}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.TextSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'C\$${p.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.titleDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            decoration: const BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Tu compra contiene productos de ${grupos.length} productores.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primarySoft,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            label: 'Subtotal',
            valor: 'C\$${_subtotalProductos.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _ResumenRow(
            label: 'Entrega',
            valor: 'C\$${_costoEntrega.toStringAsFixed(2)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
              const Spacer(),
              Text(
                'C\$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
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

  Widget _buildFooter(BuildContext context) {
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
            if (_procesando)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                ),
              )
            else
              PrimaryButton(
                label: 'Confirmar pedido',
                radius: 100,
                onPressed: () async {
                  setState(() => _procesando = true);
                  final success = await ConsumerApiService.instance.checkout(
                    CartService.instance.items,
                    "Tarjeta", // asumiendo método de pago por defecto para este ejemplo
                  );
                  if (!context.mounted) return;
                  if (success) {
                    CartService.instance.clearCart();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PedidoConfirmadoScreen(),
                      ),
                    );
                  } else {
                    setState(() => _procesando = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hubo un error al procesar tu pago. Intenta de nuevo.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.titleDark,
                  side: const BorderSide(
                    color: AppColors.cardBorder,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Text(
                  'Editar pedido',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleDark,
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primarySoftBg,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 15, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.titleDark,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        children: children,
      ),
    );
  }
}

class _FilaInfo extends StatelessWidget {
  final String valor;
  final IconData icon;

  const _FilaInfo({required this.valor, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.titleDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilaInfoVisa extends StatelessWidget {
  final String valor;

  const _FilaInfoVisa({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)),
          ),
          child: const Text(
            'VISA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1565C0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.titleDark,
          ),
        ),
      ],
    );
  }
}

class _ResumenRow extends StatelessWidget {
  final String label;
  final String valor;

  const _ResumenRow({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.TextSoft),
        ),
        const Spacer(),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.titleDark,
          ),
        ),
      ],
    );
  }
}
