import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'repartidor_demo.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class ConfiguracionRepartidor extends StatelessWidget {
  const ConfiguracionRepartidor({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = RepartidorDemo.instance;

    return RepartidorScaffold(
      titulo: 'Configuración',
      volver: true,
      fondo: AppColors.screenBg,
      body: AnimatedBuilder(
        animation: datos,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            const Text('Preferencias', style: RepartidorTextStyles.sectionTitle),
            const SizedBox(height: 12),
            RepartidorCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Disponible para entregas',
                      style: RepartidorTextStyles.menu,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    value: datos.disponible,
                    activeColor: AppColors.primaryColor,
                    onChanged: datos.cambiarDisponibilidad,
                  ),
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColors.cardBorder,
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Notificaciones',
                      style: RepartidorTextStyles.menu,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    value: datos.notificaciones,
                    activeColor: AppColors.primaryColor,
                    onChanged: datos.cambiarNotificaciones,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
