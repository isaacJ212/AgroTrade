import 'package:flutter/material.dart';
import '../../ui/widgets/productor_widgets.dart';
import '../shared/change_password_dialog.dart';

class ContrasenaProductor extends StatefulWidget {
  const ContrasenaProductor({super.key});
  @override
  State<ContrasenaProductor> createState() => _ContrasenaProductorState();
}

class _ContrasenaProductorState extends State<ContrasenaProductor> {
  @override
  Widget build(BuildContext context) => ProductorPage(
    title: 'Cambiar contraseña',
    children: [
      const ProductorCard(
        child: Text(
          'Actualiza tu contraseña de forma segura. Necesitarás confirmar la contraseña actual.',
        ),
      ),
      ProductorButton(
        label: 'Cambiar contraseña',
        icon: Icons.lock_reset,
        onPressed: () => showChangePasswordDialog(context),
      ),
      const SizedBox(height: 12),
      ProductorButton(
        label: 'Contactar soporte',
        outlined: true,
        onPressed: () => Navigator.pushNamed(context, '/productor/ayuda'),
      ),
    ],
  );
}
