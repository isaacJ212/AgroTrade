import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Detalle del pedido',
          style: AppTextStyles.Title.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),

          child: Column(
            children: [
              Container(
                width: double.infinity,

                padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),

                decoration: BoxDecoration(
                  color: AppColors.White,

                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pedido #AT-2048',
                            style: AppTextStyles.Title.copyWith(fontSize: 24),
                          ),
                        ),

                        // Estado pendiente
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F2),

                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFDADDDC),
                              width: 1,
                            ),
                          ),

                          child: Text(
                            'Pendiente',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF5F6663),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Text(
                      '06 de agosto de 2026 · 10:30 a. m.',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                    ),

                    const SizedBox(height: 18),

                    // Linea divisora
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFF546167),

                          child: Text(
                            'ML',
                            style: TextStyle(
                              color: Color(0xFFCFDBE3),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Nombre y ubicación
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                'María López',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 15,
                                    color: AppColors.TextSoft,
                                  ),

                                  const SizedBox(width: 3),

                                  Text(
                                    'Jinotepe, Carazo',
                                    style: AppTextStyles.SubTitle.copyWith(
                                      color: Color(0xFF3F493E),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        SizedBox(
                          width: 48,
                          height: 48,

                          child: OutlinedButton(
                            onPressed: () {
                            },

                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,

                              side: const BorderSide(
                                color: AppColors.accentBlue,
                                width: 1.2,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),

                            child: const Icon(
                              Icons.chat_outlined,
                              color: AppColors.accentBlue,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Productos',
                      style: AppTextStyles.Title.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 18),

                    const _OrderProductItem(
                      name: 'Tomate',
                      quantity: '4 libras',
                      unitPrice: 'C\$ 25.00',
                      total: 'C\$ 100.00',
                    ),
                    const SizedBox(height: 18),

                    const _OrderProductItem(
                      name: 'Naranjas',
                      quantity: '2 docenas',
                      unitPrice: 'C\$ 18.00',
                      total: 'C\$ 36.00',
                    ),

                    const SizedBox(height: 18),

                    const _OrderProductItem(
                      name: 'Limón',
                      quantity: '3 libras',
                      unitPrice: 'C\$ 20.00',
                      total: 'C\$ 60.00',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                        ),
                        Text(
                          'c\$ 236.00',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Entrega',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                        ),
                        Text(
                          'c\$ 40.00',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: AppTextStyles.SubTitle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'c\$ 276',
                          style: AppTextStyles.SubTitle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Confirmar pedido',
                radius: 8,
                onPressed: () {
                },
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Ver preparacion',
                onPressed: () {
                },
              ),
              const SizedBox(height: 10),
              TertiaryButton(
                label: 'Rechazar pedido',
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//clase para los detalles de un pedido
class _OrderProductItem extends StatelessWidget {
  final String name;
  final String quantity;
  final String unitPrice;
  final String total;

  const _OrderProductItem({
    required this.name,
    required this.quantity,
    required this.total,
    required this.unitPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5EC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.eco_outlined,
            color: AppColors.primaryColor,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.label.copyWith(fontSize: 14)),

              const SizedBox(height: 3),

              Text(
                '$quantity × $unitPrice',
                style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),

        Text(total, style: AppTextStyles.label.copyWith(fontSize: 13)),
      ],
    );
  }
}
