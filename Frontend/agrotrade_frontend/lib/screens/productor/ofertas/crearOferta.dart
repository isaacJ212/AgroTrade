import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../services/productor_store.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';

class CrearOferta extends StatefulWidget {
  final Producto? producto;
  const CrearOferta({super.key, this.producto});
  @override
  State<CrearOferta> createState() => _CrearOfertaState();
}

class _CrearOfertaState extends State<CrearOferta> {
  final _form = GlobalKey<FormState>();
  final _cantidad = TextEditingController();
  final _descuento = TextEditingController();
  final _fechaCtrl = TextEditingController();
  int? _productoId;
  DateTime? _fin;
  bool _activa = true;
  @override
  void initState() {
    super.initState();
    _seleccionar(widget.producto?.id);
    _descuento.addListener(_refrescar);
  }

  void _refrescar() => setState(() {});
  void _seleccionar(int? id) {
    _productoId = id;
    final oferta = id == null ? null : ProductorStore.instance.oferta(id);
    _cantidad.text = oferta == null ? '' : numero(oferta.cantidad);
    _descuento.text = oferta == null ? '' : numero(oferta.descuento);
    _fin = oferta?.fin;
    _fechaCtrl.text = _fin == null ? '' : fechaCorta(_fin!);
    _activa = oferta?.activa ?? true;
  }

  @override
  void dispose() {
    _cantidad.dispose();
    _descuento.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> _fecha() async {
    final hoy = DateTime.now();
    final inicio = DateTime(hoy.year, hoy.month, hoy.day);
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fin != null && !_fin!.isBefore(inicio) ? _fin! : inicio,
      firstDate: inicio,
      lastDate: DateTime(hoy.year + 2),
    );
    if (mounted && elegida != null)
      setState(() {
        _fin = elegida;
        _fechaCtrl.text = fechaCorta(elegida);
      });
  }

  void _guardar({required bool borrador}) {
    if (!_form.currentState!.validate()) return;
    final oferta = OfertaProductor(
      productoId: _productoId!,
      cantidad: decimal(_cantidad.text)!,
      descuento: decimal(_descuento.text)!,
      fin: _fin!,
      activa: !borrador && _activa,
    );
    if (accionProductor(
      context,
      () => ProductorStore.instance.guardarOferta(oferta),
    )) {
      mensajeProductor(
        context,
        oferta.activa ? 'Oferta activada.' : 'Oferta guardada.',
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    final productos = store.productos;
    final p = _productoId == null ? null : store.producto(_productoId!);
    final descuento = decimal(_descuento.text) ?? 0;
    final precio = p == null
        ? 0.0
        : p.precio * (1 - descuento.clamp(0, 100) / 100);
    return ProductorPage(
      title: 'Oferta de excedentes',
      children: [
        if (productos.isEmpty)
          const ProductorEmpty(
            'Agrega productos al inventario antes de crear una oferta.',
          )
        else
          ProductorCard(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int>(
                    value: _productoId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Producto'),
                    items: productos
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              item.nombre,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (id) => setState(() => _seleccionar(id)),
                    validator: (id) =>
                        id == null ? 'Selecciona un producto.' : null,
                  ),
                  const SizedBox(height: 18),
                  if (p != null) ...[
                    Text('Disponible: ${p.cantidadTexto}'),
                    const SizedBox(height: 18),
                  ],
                  ProductorField(
                    controller: _cantidad,
                    label: 'Cantidad en excedente',
                    keyboard: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      final n = decimal(v ?? '');
                      return n == null || n <= 0 || n > (p?.cantidad ?? 0)
                          ? 'Ingresa una cantidad dentro del inventario disponible.'
                          : null;
                    },
                  ),
                  ProductorField(
                    controller: _descuento,
                    label: 'Descuento (%)',
                    keyboard: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      final n = decimal(v ?? '');
                      return n == null || n <= 0 || n >= 100
                          ? 'El descuento debe estar entre 0 y 100.'
                          : null;
                    },
                  ),
                  ProductorField(
                    controller: _fechaCtrl,
                    label: 'Fecha de finalización',
                    readOnly: true,
                    onTap: _fecha,
                    validator: (_) =>
                        _fin == null ? 'Selecciona una fecha.' : null,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Activar inmediatamente'),
                    value: _activa,
                    onChanged: (v) => setState(() => _activa = v),
                  ),
                  const SizedBox(height: 16),
                  const ProductorSection('Vista previa'),
                  if (p != null) ...[
                    Text(p.nombre),
                    const SizedBox(height: 8),
                    Text(
                      '${dinero(precio)} / ${p.unidad}',
                      style: AppTextStyles.statValue,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ProductorButton(
          label: _activa ? 'Publicar oferta' : 'Guardar oferta',
          onPressed: productos.isEmpty ? null : () => _guardar(borrador: false),
        ),
        const SizedBox(height: 12),
        ProductorButton(
          label: 'Guardar borrador',
          outlined: true,
          onPressed: productos.isEmpty ? null : () => _guardar(borrador: true),
        ),
      ],
    );
  }
}
