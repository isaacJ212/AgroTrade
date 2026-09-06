import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/perfil_repartidor_widgets.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class DatosPersonalesRepartidor extends StatelessWidget {
  final String nombre;

  const DatosPersonalesRepartidor({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return RepartidorScaffold(
      titulo: 'Datos personales',
      volver: true,
      fondo: AppColors.screenBg,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const AvatarPerfilRepartidor(icono: Icons.person),
          const SizedBox(height: 32),
          CampoPerfilRepartidor(
            etiqueta: 'Nombre completo',
            valor: nombre,
          ),
          const SizedBox(height: 20),
          const CampoPerfilRepartidor(
            etiqueta: 'Correo electrónico',
            valor: 'juan.perez@example.com',
          ),
          const SizedBox(height: 20),
          const CampoPerfilRepartidor(
            etiqueta: 'Teléfono',
            valor: '+505 8888 0000',
          ),
          const SizedBox(height: 20),
          const CampoPerfilRepartidor(
            etiqueta: 'Zona de operación',
            valor: 'Jinotepe, Diriamba y Dolores',
          ),
        ],
      ),
    );
  }
}
