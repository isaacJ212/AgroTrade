import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'seguimientoPedido.dart';

class DetallePedidoComprador extends StatelessWidget {
  final String numeroPedido;

  const DetallePedidoComprador({
    super.key,
    required this.numeroPedido,
  });

  @override
  Widget build(BuildContext context) {
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
          'Pedido $numeroPedido',
          style: AppTextStyles.Title,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido Confirmado',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.TextMain,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
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
                  MaterialPageRoute(builder: (_) => const SeguimientoPedidoScreen()),
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
                children: [
                  _buildOrderItem('Tomates Frescos (Caja)', '2x', '\$ 45.00'),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
                  _buildOrderItem('Cebolla Morada (Saco)', '1x', '\$ 35.00'),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
                  _buildOrderItem('Papa Blanca (Saco)', '1x', '\$ 66.00'),
                ],
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
                  _buildPaymentRow('Subtotal', '\$ 146.00'),
                  const SizedBox(height: 8),
                  _buildPaymentRow('Costo de envío', '\$ 10.00'),
                  const SizedBox(height: 8),
                  _buildPaymentRow('Descuentos', '-\$ 0.00', isDiscount: true),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: AppColors.cardBorder),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.TextMain,
                        ),
                      ),
                      Text(
                        '\$ 156.00',
                        style: TextStyle(
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
