import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/productor_models.dart';
import '../../services/productor_store.dart';
import '../../ui/widgets/productor_widgets.dart';

class EditarFincaScreen extends StatefulWidget {
  const EditarFincaScreen({super.key});
  @override
  State<EditarFincaScreen> createState() => _EditarFincaScreenState();
}

class _EditarFincaScreenState extends State<EditarFincaScreen> {
  final _form = GlobalKey<FormState>();
  late final DatosFinca _initial = ProductorStore.instance.finca;
  late final _nombre = TextEditingController(text: _initial.nombre);
  late final _tamano = TextEditingController(text: numero(_initial.hectareas));
  late final _ubicacion = TextEditingController(text: _initial.ubicacion);
  final _ubicacionFocus = FocusNode();
  late String _cultivo = _initial.cultivo;
  late Uint8List? _foto = _initial.foto;
  bool _cargando = false;
  @override
  void dispose() {
    _nombre.dispose();
    _tamano.dispose();
    _ubicacion.dispose();
    _ubicacionFocus.dispose();
    super.dispose();
  }

  Future<void> _cambiarFoto() async {
    setState(() => _cargando = true);
    try {
      final selected = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (selected != null) {
        final bytes = await selected.readAsBytes();
        if (mounted) setState(() => _foto = bytes);
      }
    } catch (_) {
      if (mounted)
        mensajeProductor(
          context,
          'No se pudo abrir la imagen. Revisa el acceso a la galería.',
        );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _guardar() {
    if (!_form.currentState!.validate()) return;
    ProductorStore.instance.guardarFinca(
      DatosFinca(
        nombre: _nombre.text.trim(),
        ubicacion: _ubicacion.text.trim(),
        cultivo: _cultivo,
        hectareas: decimal(_tamano.text)!,
        descripcion: _initial.descripcion,
        portadaUrl: _initial.portadaUrl,
        foto: _foto,
      ),
    );
    mensajeProductor(context, 'Información de la finca actualizada.');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => ProductorPage(
    title: 'Editar finca',
    bottom: ProductorButton(
      label: 'Guardar cambios',
      onPressed: _cargando ? null : _guardar,
    ),
    children: [
      Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductorImage(
                  url: _initial.portadaUrl,
                  bytes: _foto,
                  height: 160,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton.filled(
                    tooltip: 'Cambiar foto de la finca',
                    onPressed: _cargando ? null : _cambiarFoto,
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const ProductorSection('Datos generales'),
            ProductorField(
              controller: _nombre,
              label: 'Nombre de la finca',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingresa el nombre.' : null,
            ),
            ProductorField(
              controller: _tamano,
              label: 'Tamaño (hectáreas)',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => decimal(v ?? '') == null || decimal(v!)! <= 0
                  ? 'Ingresa un tamaño válido.'
                  : null,
            ),
            DropdownButtonFormField<String>(
              value: _cultivo,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Cultivo principal'),
              items: {
                'Café',
                'Cacao',
                'Frijoles',
                'Hortalizas',
                _cultivo,
              }.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => _cultivo = v!),
            ),
            const SizedBox(height: 20),
            const ProductorSection('Ubicación'),
            ProductorField(
              controller: _ubicacion,
              focusNode: _ubicacionFocus,
              label: 'Dirección exacta',
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Ingresa la dirección.'
                  : null,
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _ubicacion,
              builder: (_, value, __) => ProductorMap(
                label: value.text.isEmpty
                    ? 'Ubicación de la finca'
                    : value.text,
              ),
            ),
            const SizedBox(height: 12),
            ProductorButton(
              label: 'Editar dirección',
              outlined: true,
              icon: Icons.location_on_outlined,
              onPressed: () => _ubicacionFocus.requestFocus(),
            ),
          ],
        ),
      ),
    ],
  );
}
