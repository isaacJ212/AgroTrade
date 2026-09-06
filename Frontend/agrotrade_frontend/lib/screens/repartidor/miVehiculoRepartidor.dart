import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/perfil_repartidor_widgets.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class MiVehiculoRepartidor extends StatelessWidget {
  const MiVehiculoRepartidor({super.key});

  @override
  Widget build(BuildContext context) {
    return RepartidorScaffold(
      titulo: 'Mi vehículo',
      volver: true,
      fondo: AppColors.screenBg,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: const [
          AvatarPerfilRepartidor(icono: Icons.two_wheeler),
          SizedBox(height: 32),
          CampoPerfilRepartidor(
            etiqueta: 'Motocicleta',
            valor: 'Bajaj Boxer 150',
          ),
          SizedBox(height: 20),
          CampoPerfilRepartidor(
            etiqueta: 'Placa',
            valor: 'M 123456',
          ),
        ],
      ),
    );
  }
}
