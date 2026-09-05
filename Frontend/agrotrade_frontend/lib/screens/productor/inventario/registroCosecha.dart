import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../services/productor_store.dart';
import '../../../routes/app_routes.dart';
import '../../../ui/widgets/productor_widgets.dart';
import '../precio_justo/calculadoraPrecioJusto.dart';

class RegistroCosecha extends StatefulWidget {
  final Producto? producto;
  const RegistroCosecha({super.key, this.producto});
  @override
  State<RegistroCosecha> createState() => _RegistroCosechaState();
}

class _RegistroCosechaState extends State<RegistroCosecha> {
  final _form = GlobalKey<FormState>();
  late final _cantidad = TextEditingController(
    text: widget.producto?.id == 0 ? '' : widget.producto?.cantidad.toString(),
  );
  late final _costo = TextEditingController(
    text: (widget.producto?.costoProduccion ?? 0) > 0
        ? widget.producto!.costoProduccion.toStringAsFixed(2)
        : '',
  );
  late final _precio = TextEditingController(
    text: (widget.producto?.precio ?? 0) > 0
        ? widget.producto!.precio.toStringAsFixed(2)
        : '',
  );
  late DateTime? _fecha = widget.producto?.fechaCosecha;
  late final _fechaCtrl = TextEditingController(
    text: _fecha == null ? '' : fechaCorta(_fecha!),
  );
  late bool _publicado = widget.producto?.publicado ?? true;
  bool _guardando = false;
  @override
  void dispose() {
    _cantidad.dispose();
    _costo.dispose();
    _precio.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final initial = _fecha != null && !_fecha!.isAfter(hoy) ? _fecha! : hoy;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: hoy,
    );
    if (date != null && mounted)
      setState(() {
        _fecha = date;
        _fechaCtrl.text = fechaCorta(date);
      });
  }

  Future<void> _calcular() async {
    final costo = decimal(_costo.text);
    final cantidad = decimal(_cantidad.text);
    if (costo == null || costo <= 0 || cantidad == null || cantidad <= 0) {
      mensajeProductor(
        context,
        'Ingresa primero la cantidad y el costo por unidad.',
      );
      return;
    }
    final precio = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => CalculadoraPrecioJusto(
          nombreProducto: widget.producto!.nombre,
          unidadInicial: widget.producto!.unidad,
          costoInicial: costo * cantidad,
          cantidadInicial: cantidad,
          devolverPrecio: true,
        ),
      ),
    );
    if (mounted && precio != null)
      setState(() => _precio.text = precio.toStringAsFixed(2));
  }

  void _guardar() {
    if (_guardando || !_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final p = widget.producto!.copyWith(
      cantidad: decimal(_cantidad.text)!,
      costoProduccion: decimal(_costo.text)!,
      precio: decimal(_precio.text)!,
      fechaCosecha: _fecha,
      publicado: _publicado,
    );
    if (accionProductor(
      context,
      () => ProductorStore.instance.guardarProducto(p),
    )) {
      mensajeProductor(context, 'Inventario actualizado.');
      Navigator.pop(context, true);
    } else {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.producto;
    if (p == null)
      return ProductorPage(
        title: 'Registro de cosecha',
        children: [
          const ProductorEmpty(
            'Selecciona un producto para registrar su cosecha.',
          ),
          ProductorButton(
            label: 'Ir al inventario',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.inventario),
          ),
        ],
      );
    return ProductorPage(
      title: 'Registro de cosecha',
      bottom: ProductorButton(
        label: 'Guardar inventario',
        icon: Icons.save_outlined,
        onPressed: _guardando ? null : _guardar,
      ),
      children: [
        Text(p.nombre),
        const SizedBox(height: 16),
        Form(
          key: _form,
          child: Column(
            children: [
              ProductorCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProductorSection('Detalles del producto'),
                    ProductorField(
                      controller: _cantidad,
                      label: 'Cantidad disponible (${p.unidad})',
                      keyboard: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) =>
                          decimal(v ?? '') == null || decimal(v!)! < 0
                          ? 'Ingresa una cantidad válida.'
                          : null,
                    ),
                    ProductorField(
                      controller: _fechaCtrl,
                      label: 'Fecha de cosecha',
                      readOnly: true,
                      onTap: _seleccionarFecha,
                      validator: (_) =>
                          _fecha == null ? 'Selecciona la fecha.' : null,
                    ),
                  ],
                ),
              ),
              ProductorCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProductorSection('Costos y precios'),
                    ProductorField(
                      controller: _costo,
                      label: 'Costo de producción por ${p.unidad}',
                      keyboard: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) =>
                          decimal(v ?? '') == null || decimal(v!)! <= 0
                          ? 'Ingresa un costo mayor que cero.'
                          : null,
                    ),
                    ProductorField(
                      controller: _precio,
                      label: 'Precio de venta por ${p.unidad}',
                      keyboard: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        final precio = decimal(v ?? '');
                        if (precio == null || precio <= 0)
                          return 'Ingresa un precio válido.';
                        if (precio < (decimal(_costo.text) ?? 0))
                          return 'El precio no puede ser menor al costo.';
                        return null;
                      },
                    ),
                    ProductorButton(
                      label: 'Calcular precio justo',
                      outlined: true,
                      icon: Icons.calculate_outlined,
                      onPressed: _calcular,
                    ),
                  ],
                ),
              ),
              ProductorCard(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Disponible en el mercado'),
                  value: _publicado,
                  onChanged: (v) => setState(() => _publicado = v),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
