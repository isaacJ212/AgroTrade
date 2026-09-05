import 'package:flutter/material.dart';
import '../../ui/widgets/productor_widgets.dart';

class ContrasenaProductor extends StatefulWidget {
  const ContrasenaProductor({super.key});
  @override
  State<ContrasenaProductor> createState() => _ContrasenaProductorState();
}

class _ContrasenaProductorState extends State<ContrasenaProductor> {
  final _actual = TextEditingController();
  final _nueva = TextEditingController();
  final _confirmacion = TextEditingController();
  @override
  void dispose() {
    _actual.dispose();
    _nueva.dispose();
    _confirmacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProductorPage(
    title: 'Cambiar contraseña',
    children: [
      const ProductorCard(
        child: Text(
          'El cambio de contraseña aún no está disponible. Contacta a soporte si necesitas recuperar el acceso.',
        ),
      ),
      ProductorField(
        controller: _actual,
        label: 'Contraseña actual',
        obscure: true,
        readOnly: true,
      ),
      ProductorField(
        controller: _nueva,
        label: 'Nueva contraseña',
        obscure: true,
        readOnly: true,
      ),
      ProductorField(
        controller: _confirmacion,
        label: 'Confirmar nueva contraseña',
        obscure: true,
        readOnly: true,
      ),
      const ProductorButton(label: 'Guardar contraseña', onPressed: null),
      const SizedBox(height: 12),
      ProductorButton(
        label: 'Contactar soporte',
        outlined: true,
        onPressed: () => Navigator.pushNamed(context, '/productor/ayuda'),
      ),
    ],
  );
}
