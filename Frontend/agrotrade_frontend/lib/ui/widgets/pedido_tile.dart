import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'status_chip.dart';

class PedidoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String titulo;
  final String comprador;
  final String monto;
  final String estado;

  const PedidoTile({
    super.key,
    required this.icon,
    this.iconColor = AppColors.primaryColor,
    required this.titulo,
    required this.comprador,
    required this.monto,
    required this.estado,
  });

  bool get _completado => estado.toLowerCase() == 'completado';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.tileBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Comprador: $comprador',
                  style: AppTextStyles.SubTitle.copyWith(
                    color: AppColors.bodyText,
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
                monto,
                style: AppTextStyles.label.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 6),
              StatusChip(
                label: estado,
                background: _completado
                    ? AppColors.chipGrey
                    : AppColors.primaryColor.withOpacity(0.2),
                color: _completado
                    ? AppColors.bodyText
                    : AppColors.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
