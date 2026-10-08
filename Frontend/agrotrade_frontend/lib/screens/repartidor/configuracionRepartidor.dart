import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/profile_menu_item.dart';
import '../shared/change_password_dialog.dart';
import 'centroAyudaRepartidor.dart';

class ConfiguracionRepartidor extends StatefulWidget {
  const ConfiguracionRepartidor({super.key});

  @override
  State<ConfiguracionRepartidor> createState() => _ConfiguracionRepartidorState();
}

class _ConfiguracionRepartidorState extends State<ConfiguracionRepartidor> {
  bool _disponible = false;
  bool _notificaciones = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('Configuración', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          const Text('Preferencias', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Disponible para entregas', style: AppTextStyles.label),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  value: _disponible,
                  activeThumbColor: AppColors.primaryColor,
                  onChanged: (value) => setState(() => _disponible = value),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.cardBorder),
                SwitchListTile(
                  title: const Text('Notificaciones', style: AppTextStyles.label),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  value: _notificaciones,
                  activeThumbColor: AppColors.primaryColor,
                  onChanged: (value) => setState(() => _notificaciones = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Cuenta', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Cambiar contraseña',
                  onTap: () => showChangePasswordDialog(context),
                ),
                const Divider(height: 1, indent: 48, color: AppColors.cardBorder),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Centro de ayuda',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CentroAyudaRepartidor()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}