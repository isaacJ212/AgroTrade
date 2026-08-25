import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../../models/entrega.dart';

class NotificacionEntregaTile extends StatelessWidget {
  final NotificacionEntrega notificacion;
  final VoidCallback? onTap;

  const NotificacionEntregaTile({
    super.key,
    required this.notificacion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #${notificacion.pedidoId}',
                    style: AppTextStyles.label.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notificacion.zonaEntrega,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notificacion.tiempoTranscurrido,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notificacion.totalFormateado,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.bodyText,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
