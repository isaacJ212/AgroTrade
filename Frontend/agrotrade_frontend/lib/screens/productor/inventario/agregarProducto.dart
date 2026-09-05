import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/productor_models.dart';
import '../../../ui/widgets/productor_widgets.dart';
import 'registroCosecha.dart';

class AgregarProducto extends StatefulWidget {
  final Producto? producto;
  const AgregarProducto({super.key, this.producto});
  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final _form = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.producto?.nombre);
  late final _descripcion = TextEditingController(
    text: widget.producto?.descripcion,
  );
  late final _precio = TextEditingController(
    text: widget.producto?.precio.toStringAsFixed(2),
  );
  late String? _categoria = widget.producto?.categoria;
  late String? _unidad = widget.producto?.unidad;
  late final List<Uint8List> _fotos = [...?widget.producto?.fotos];
  bool _seleccionando = false;
  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    _precio.dispose();
    super.dispose();
  }

  Future<void> _agregarFoto() async {
    if (_seleccionando || _fotos.length >= 5) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(sheet, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(sheet, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    setState(() => _seleccionando = true);
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _fotos.add(bytes));
    } catch (_) {
      if (mounted)
        mensajeProductor(
          context,
          'No se pudo abrir la imagen. Revisa los permisos o usa la galería.',
        );
    } finally {
      if (mounted) setState(() => _seleccionando = false);
    }
  }

  Future<void> _continuar() async {
    if (!_form.currentState!.validate()) return;
    final base =
        widget.producto ??
        const Producto(
          id: 0,
          nombre: '',
          cantidad: 0,
          unidad: 'kg',
          precio: 0,
          estado: EstadoProducto.agotado,
          imagenUrl: '',
        );
    final draft = base.copyWith(
      nombre: _nombre.text.trim(),
      descripcion: _descripcion.text.trim(),
      categoria: _categoria,
      unidad: _unidad,
      precio: decimal(_precio.text) ?? base.precio,
      fotos: List.unmodifiable(_fotos),
    );
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RegistroCosecha(producto: draft)),
    );
    if (mounted && saved == true) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final unidades = {
      'kg',
      'Tonelada',
      'Caja',
      'Docena',
      if (_unidad != null) _unidad!,
    };
    final categorias = {
      'Frutas',
      'Verduras',
      'Granos',
      'Lácteos',
      if (_categoria != null) _categoria!,
    };
    return ProductorPage(
      title: widget.producto == null ? 'Agregar producto' : 'Editar producto',
      bottom: ProductorButton(
        label: 'Continuar',
        onPressed: _seleccionando ? null : _continuar,
      ),
      children: [
        ProductorCard(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductorField(
                  controller: _nombre,
                  label: 'Nombre del producto',
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Ingresa el nombre.'
                      : null,
                ),
                DropdownButtonFormField<String>(
                  value: _categoria,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: categorias
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoria = v),
                  validator: (v) =>
                      v == null ? 'Selecciona una categoría.' : null,
                ),
                const SizedBox(height: 18),
                ProductorField(
                  controller: _descripcion,
                  label: 'Descripción',
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  value: _unidad,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Unidad de medida',
                  ),
                  items: unidades
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (v) => setState(() => _unidad = v),
                  validator: (v) => v == null ? 'Selecciona una unidad.' : null,
                ),
                const SizedBox(height: 18),
                ProductorField(
                  controller: _precio,
                  label: 'Precio estimado por unidad (opcional)',
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? null
                      : decimal(v) == null || decimal(v)! <= 0
                      ? 'Ingresa un precio mayor que cero.'
                      : null,
                ),
                const ProductorSection('Fotos del producto'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (_fotos.isEmpty &&
                        (widget.producto?.imagenUrl.isNotEmpty ?? false))
                      ProductorImage(
                        url: widget.producto!.imagenUrl,
                        width: 92,
                        height: 92,
                      ),
                    for (var i = 0; i < _fotos.length; i++)
                      Stack(
                        children: [
                          ProductorImage(
                            bytes: _fotos[i],
                            width: 92,
                            height: 92,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton.filled(
                              tooltip: 'Quitar foto',
                              onPressed: () =>
                                  setState(() => _fotos.removeAt(i)),
                              icon: const Icon(Icons.close, size: 18),
                            ),
                          ),
                        ],
                      ),
                    if (_fotos.length < 5)
                      SizedBox(
                        width: 110,
                        height: 92,
                        child: OutlinedButton(
                          onPressed: _seleccionando ? null : _agregarFoto,
                          child: const Icon(Icons.add_a_photo_outlined),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Hasta 5 fotos.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
