import 'package:flutter/material.dart';
import '../ui/app_theme.dart';

class ConfirmarEntregaRepartidor extends StatefulWidget {
  const ConfirmarEntregaRepartidor({super.key});

  @override
  State<ConfirmarEntregaRepartidor> createState() =>
      _ConfirmarEntregaRepartidorState();
}

class _ConfirmarEntregaRepartidorState
    extends State<ConfirmarEntregaRepartidor> {
  bool _confirmado = false;

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceAlt,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
        title: const Text(
          'Confirmar entrega',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: const [
          SizedBox(width: 48),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderInfo(
              title: 'Entrega #AT-2051',
              status: 'En destino',
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                setState(() => _confirmado = !_confirmado);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.bodyText),
                      ),
                      child: _confirmado
                          ? const Icon(Icons.check, size: 16, color: AppColors.primaryColor)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Confirmo que el pedido fue entregado correctamente.',
                        style: AppTextStyles.label.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Comprobante (Opcional)',
              style: AppTextStyles.label.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ProofBox(
                    icon: Icons.photo_camera_outlined,
                    label: 'Tomar foto',
                    onTap: () => _showSnack('Cámara'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProofBox(
                    icon: Icons.note_add_outlined,
                    label: 'Agregar nota',
                    onTap: () => _showSnack('Agregar nota'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Nota de entrega',
              style: AppTextStyles.label.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              minLines: 4,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Agregá una observación si es necesario.',
                hintStyle: AppTextStyles.SubTitle.copyWith(
                  fontSize: 14,
                  color: AppColors.bodyText.withOpacity(0.5),
                ),
                filled: true,
                fillColor: AppColors.scaffoldBg,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.bodyText),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.bodyText),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.scaffoldBg,
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _confirmado
                      ? () => _showSnack('Entrega confirmada')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.fabIcon,
                    disabledBackgroundColor: AppColors.primaryColor,
                    disabledForegroundColor: AppColors.fabIcon,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Confirmar entrega',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _showSnack('Incidencia reportada'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.inputErrorColor,
                    side: const BorderSide(color: AppColors.inputErrorColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Reportar incidencia',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final String title;
  final String status;

  const _HeaderInfo({
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.label.copyWith(fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primarySoft),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: AppTextStyles.chip.copyWith(color: AppColors.primarySoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProofBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProofBox({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.chipGrey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primarySoft, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.chip.copyWith(
                color: AppColors.primarySoft,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
