import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../../models/entrega.dart';
import 'status_chip.dart';

class EntregaDetalleCard extends StatelessWidget {
  final NotificacionEntrega entrega;
  final VoidCallback? onVerDetalle;
  final VoidCallback? onContinuar;

  const EntregaDetalleCard({
    super.key,
    required this.entrega,
    this.onVerDetalle,
    this.onContinuar,
  });

  Color get _colorEstado {
    switch (entrega.estado) {
      case 'Completado':
        return AppColors.bodyText;
      case 'En curso':
        return AppColors.accentBlue;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: _colorEstado, width: 4),
          top: BorderSide(color: AppColors.cardBorder),
          right: BorderSide(color: AppColors.cardBorder),
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              ChipEstado(texto: entrega.estado, color: _colorEstado),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entrega.horaLabel,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entrega.zonaEntrega,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _filaRuta(
                  Icons.location_on_outlined,
                  'Recogida',
                  entrega.zonaEntrega,
                ),
                const SizedBox(height: 10),
                _filaRuta(Icons.flag_outlined, 'Destino', entrega.zonaEntrega),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _footer(),
        ],
      ),
    );
  }

  Widget _filaRuta(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.SubTitle.copyWith(fontSize: 12)),
            const SizedBox(height: 2),
            Text(valor, style: AppTextStyles.label.copyWith(fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _footer() {
    switch (entrega.estado) {
      case 'En curso':
        return SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: onContinuar ?? () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.White,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Continuar entrega',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        );
      case 'Completado':
        return Row(
          children: [
            const Icon(
              Icons.verified_outlined,
              size: 16,
              color: AppColors.bodyText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Entregada a ${entrega.pedidoId} (Firma registrada)',
                style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
              ),
            ),
          ],
        );
      default:
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: onVerDetalle ?? () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentBlue,
                side: const BorderSide(color: AppColors.accentBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Ver detalle',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
    }
  }
}
