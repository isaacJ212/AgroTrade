import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'seguimientoPedido.dart';

import '../../services/consumer_api_service.dart';

class DetallePedidoComprador extends StatefulWidget {
  final String numeroPedido;

  const DetallePedidoComprador({
    super.key,
    required this.numeroPedido,
  });

  @override
  State<DetallePedidoComprador> createState() => _DetallePedidoCompradorState();
}

class _DetallePedidoCompradorState extends State<DetallePedidoComprador> {
  Map<String, dynamic> _detalle = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDetalle();
  }

  Future<void> _cargarDetalle() async {
    final detalle = await ConsumerApiService.instance.getPedidoDetalle(widget.numeroPedido);
    if (mounted) {
      setState(() {
        _detalle = detalle;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detallesItems = _detalle['detalles'] as List? ?? [];
    final double subtotal = _detalle['subtotal']?.toDouble() ?? 146.00;
    final double total = _detalle['total']?.toDouble() ?? 156.00;
    final double envio = 10.0;
    final estadoEnvio = _detalle['estadoEnvio'] ?? 'Confirmado';
    
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pedido ${widget.numeroPedido}',
          style: AppTextStyles.Title,
        ),
        centerTitle: true,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen de estado
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySoftBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.primaryColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedido $estadoEnvio',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.TextMain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'El productor está preparando tus productos.',
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
                  const SizedBox(height: 20),
                  
                
                  PrimaryButton(
                    label: 'Ver Seguimiento',
                    radius: 12,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SeguimientoPedidoScreen(idPedido: widget.numeroPedido)),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Detalles del pedido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.TextMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Items del Pedido
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: detallesItems.isEmpty
                          ? [
                              _buildOrderItem('Tomates Frescos (Caja)', '2x', '\$ 45.00'),
                              const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
                              _buildOrderItem('Cebolla Morada (Saco)', '1x', '\$ 35.00'),
                              const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
                              _buildOrderItem('Papa Blanca (Saco)', '1x', '\$ 66.00'),
                            ]
                          : detallesItems.map<Widget>((item) {
                              final productName = item['producto']?['nombre'] ?? 'Producto';
                              final quantity = item['cantidad']?.toString() ?? '1';
                              final price = item['precioUnitario']?.toDouble() ?? 0.0;
                              final sub = price * int.parse(quantity);
                              return Column(
                                children: [
                                  _buildOrderItem(productName, '${quantity}x', 'C\$ ${sub.toStringAsFixed(2)}'),
                                  if (item != detallesItems.last)
                                    const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
                                ],
                              );
                            }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Resumen de Pago',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.TextMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Desglose de Pago
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildPaymentRow('Subtotal', 'C\$ ${subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildPaymentRow('Costo de envío', 'C\$ ${envio.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildPaymentRow('Descuentos', '-C\$ 0.00', isDiscount: true),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: AppColors.cardBorder),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.TextMain,
                              ),
                            ),
                            Text(
                              'C\$ ${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Información de Envío',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.TextMain,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mercado Central, Puesto 42',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.TextMain,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jinotepe, Carazo, Nicaragua',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.TextSoft,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String title, String quantity, String price) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primarySoftBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.shopping_basket_outlined, color: AppColors.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.TextMain,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'Cantidad: $quantity',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.TextSoft,
          ),
        ),
      ),
      trailing: Text(
        price,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.TextMain,
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.TextSoft,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : AppColors.TextMain,
          ),
        ),
      ],
    );
  }
}
