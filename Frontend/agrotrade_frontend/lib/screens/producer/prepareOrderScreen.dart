import 'package:agrotrade_frontend/screens/producer/orderDetailScreen.dart';
import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

class PrepareOrderScreen extends StatelessWidget {
  const PrepareOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Preparación del pedido',
          style: AppTextStyles.Title.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Preparar pedido',
                      style: AppTextStyles.Title.copyWith(fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'En preparación',
                      style: TextStyle(
                        color: AppColors.White,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                'Pedido #AT-2048',
                style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
              ),

              const SizedBox(height: 18),

              // Estado del pedido
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                decoration: BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E5E4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    _OrderStatusItem(
                      label: 'Confirmado',
                      state: OrderStatusState.completed,
                      showLine: true,
                    ),
                    _OrderStatusItem(
                      label: 'En preparación',
                      state: OrderStatusState.current,
                      showLine: true,
                    ),
                    _OrderStatusItem(
                      label: 'Listo para entregar',
                      state: OrderStatusState.pending,
                      showLine: true,
                    ),
                    _OrderStatusItem(
                      label: 'En camino',
                      state: OrderStatusState.pending,
                      showLine: true,
                    ),
                    _OrderStatusItem(
                      label: 'Entregado',
                      state: OrderStatusState.pending,
                      showLine: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Productos
              Text(
                'Productos a preparar',
                style: AppTextStyles.Title.copyWith(fontSize: 24),
              ),

              const SizedBox(height: 18),

              // Progreso
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2 de 3 productos preparados',
                    style: AppTextStyles.SubTitle.copyWith(
                      fontSize: 14,
                      color: AppColors.TextMain,
                    ),
                  ),
                  const Text(
                    '66%',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  value: 0.66,
                  minHeight: 6,
                  backgroundColor: Color(0xFFE4E8E6),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Lista de productos
              const _PreparationProductCard(
                productName: 'Tomate',
                quantity: '4 libras',
                isPrepared: true,
              ),

              const SizedBox(height: 12),

              const _PreparationProductCard(
                productName: 'Naranjas',
                quantity: '2 docenas',
                isPrepared: true,
              ),

              const SizedBox(height: 12),

              const _PreparationProductCard(
                productName: 'Limón',
                quantity: '3 libras',
                isPrepared: false,
              ),

              const SizedBox(height: 26),

              // Nota del comprador
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD8E6FF)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info,
                      color: AppColors.accentBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nota del comprador',
                            style: AppTextStyles.label.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Seleccionar los tomates más maduros, por favor.',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Marcar como listo',
                radius: 10,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderDetailsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              SecondaryButton(
                label: 'Enviar mensaje al comprador',
                icon: Icons.chat_outlined,
                onPressed: () {
                  // Navegación al chat se conectará posteriormente.
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Estados del pedido
enum OrderStatusState { completed, current, pending }

// Item individual del estado
class _OrderStatusItem extends StatelessWidget {
  final String label;
  final OrderStatusState state;
  final bool showLine;

  const _OrderStatusItem({
    required this.label,
    required this.state,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = state == OrderStatusState.completed;
    final bool isCurrent = state == OrderStatusState.current;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                if (isCompleted)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 11,
                      color: AppColors.White,
                    ),
                  )
                else if (isCurrent)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accentBlue, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.accentBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF7C8B82),
                        width: 1.3,
                      ),
                    ),
                  ),

                if (showLine)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: isCompleted
                          ? AppColors.accentBlue
                          : const Color(0xFFD5D9D7),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCurrent
                      ? AppColors.accentBlue
                      : isCompleted
                      ? AppColors.TextMain
                      : AppColors.TextSoft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta de producto
class _PreparationProductCard extends StatelessWidget {
  final String productName;
  final String quantity;
  final bool isPrepared;

  const _PreparationProductCard({
    required this.productName,
    required this.quantity,
    required this.isPrepared,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: isPrepared ? const Color(0xFFF1F8F4) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrepared ? const Color(0xFFCFE5D8) : const Color(0xFFE2E2E2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isPrepared ? AppColors.primaryColor : AppColors.White,
              border: Border.all(
                color: isPrepared
                    ? AppColors.primaryColor
                    : const Color(0xFF748078),
                width: 1.4,
              ),
            ),
            child: isPrepared
                ? const Icon(Icons.check, size: 14, color: AppColors.White)
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isPrepared ? AppColors.TextSoft : AppColors.TextMain,
                    decoration: isPrepared
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quantity,
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
