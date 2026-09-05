import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/productor_models.dart';
import '../../services/productor_store.dart';
import '../../ui/widgets/productor_widgets.dart';

class DatosPersonalesProductor extends StatefulWidget {
  const DatosPersonalesProductor({super.key});
  @override
  State<DatosPersonalesProductor> createState() =>
      _DatosPersonalesProductorState();
}

class _DatosPersonalesProductorState extends State<DatosPersonalesProductor> {
  final _form = GlobalKey<FormState>();
  late final _datos = ProductorStore.instance.persona;
  late final _nombre = TextEditingController(text: _datos.nombre);
  late final _correo = TextEditingController(text: _datos.correo);
  late final _telefono = TextEditingController(text: _datos.telefono);
  late final _ubicacion = TextEditingController(text: _datos.ubicacion);
  late Uint8List? _foto = _datos.foto;
  bool _cargando = false;
  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _telefono.dispose();
    _ubicacion.dispose();
    super.dispose();
  }

  Future<void> _elegirFoto() async {
    setState(() => _cargando = true);
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 600,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (mounted) setState(() => _foto = bytes);
      }
    } catch (_) {
      if (mounted)
        mensajeProductor(
          context,
          'No se pudo abrir la imagen. Revisa los permisos de la galería.',
        );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _guardar() {
    if (!_form.currentState!.validate()) return;
    ProductorStore.instance.guardarPersona(
      DatosProductor(
        nombre: _nombre.text.trim(),
        correo: _correo.text.trim(),
        telefono: _telefono.text.trim(),
        ubicacion: _ubicacion.text.trim(),
        foto: _foto,
      ),
    );
    mensajeProductor(context, 'Perfil actualizado.');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => ProductorPage(
    title: 'Editar perfil',
    actions: [
      TextButton(
        onPressed: _cargando ? null : _guardar,
        child: const Text('Guardar'),
      ),
    ],
    children: [
      Form(
        key: _form,
        child: Column(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: ProductorImage(
                    bytes: _foto,
                    width: 100,
                    height: 100,
                    icon: Icons.person,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton.filled(
                    tooltip: 'Cambiar foto',
                    onPressed: _cargando ? null : _elegirFoto,
                    icon: const Icon(Icons.camera_alt, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ProductorField(
              controller: _nombre,
              label: 'Nombre completo',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingresa tu nombre.' : null,
            ),
            ProductorField(
              controller: _correo,
              label: 'Correo electrónico',
              keyboard: TextInputType.emailAddress,
              validator: (v) =>
                  v == null ||
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())
                  ? 'Revisa el correo.'
                  : null,
            ),
            ProductorField(
              controller: _telefono,
              label: 'Teléfono',
              keyboard: TextInputType.phone,
              validator: (v) =>
                  v == null || v.replaceAll(RegExp(r'\D'), '').length < 8
                  ? 'Revisa el teléfono.'
                  : null,
            ),
            ProductorField(
              controller: _ubicacion,
              label: 'Ubicación',
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Ingresa tu ubicación.'
                  : null,
            ),
            ProductorButton(
              label: 'Cambiar contraseña',
              outlined: true,
              icon: Icons.lock_outline,
              onPressed: () =>
                  Navigator.pushNamed(context, '/productor/contrasena'),
            ),
          ],
        ),
      ),
    ],
  );
}
