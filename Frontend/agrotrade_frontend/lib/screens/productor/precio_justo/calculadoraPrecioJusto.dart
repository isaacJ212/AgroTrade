import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../ui/widgets/productor_widgets.dart';
import 'resultadoPrecioJusto.dart';

class CalculadoraPrecioJusto extends StatefulWidget {
  final String? nombreProducto;
  final String unidadInicial;
  final double? costoInicial, cantidadInicial;
  final bool devolverPrecio;
  const CalculadoraPrecioJusto({
    super.key,
    this.nombreProducto,
    this.unidadInicial = 'kg',
    this.costoInicial,
    this.cantidadInicial,
    this.devolverPrecio = false,
  });
  @override
  State<CalculadoraPrecioJusto> createState() => _CalculadoraPrecioJustoState();
}

class _CalculadoraPrecioJustoState extends State<CalculadoraPrecioJusto> {
  final _form = GlobalKey<FormState>();
  late final _costo = TextEditingController(
    text: widget.costoInicial?.toStringAsFixed(2),
  );
  late final _cantidad = TextEditingController(
    text: widget.cantidadInicial?.toString(),
  );
  late String _unidad = widget.unidadInicial;
  double _margen = 30;
  @override
  void dispose() {
    _costo.dispose();
    _cantidad.dispose();
    super.dispose();
  }

  Future<void> _calcular() async {
    if (!_form.currentState!.validate()) return;
    final costo = decimal(_costo.text)! / decimal(_cantidad.text)!;
    final precio = double.parse(
      (costo * (1 + _margen / 100)).toStringAsFixed(2),
    );
    final resultado = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoPrecioJusto(
          nombreProducto: widget.nombreProducto ?? 'Producto agrícola',
          precioSugerido: precio,
          costoTotal: costo,
          margenGanancia: precio - costo,
          unidad: _unidad,
          permitirAplicar: widget.devolverPrecio,
          desglose: [
            {
              'icon': Icons.payments_outlined,
              'label': 'Costo de producción por unidad',
              'value': costo,
            },
          ],
        ),
      ),
    );
    if (mounted && resultado != null && widget.devolverPrecio)
      Navigator.pop(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    final unidades = {
      'kg',
      'Tonelada',
      'Caja',
      'Docena',
      'libra',
      widget.unidadInicial,
    };
    return ProductorPage(
      title: 'Calculadora de precio justo',
      bottom: ProductorButton(
        label: 'Calcular precio',
        icon: Icons.calculate_outlined,
        onPressed: _calcular,
      ),
      children: [
        if (widget.nombreProducto != null) ...[
          Text(widget.nombreProducto!),
          const SizedBox(height: 16),
        ],
        ProductorCard(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductorSection('Costos de producción'),
                ProductorField(
                  controller: _costo,
                  label: 'Costo total de producción',
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) =>
                      decimal(v ?? '') == null || decimal(v!)! <= 0
                      ? 'Ingresa un costo válido.'
                      : null,
                ),
                ProductorField(
                  controller: _cantidad,
                  label: 'Cantidad producida',
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) =>
                      decimal(v ?? '') == null || decimal(v!)! <= 0
                      ? 'Ingresa una cantidad mayor que cero.'
                      : null,
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
                  // Al regresar un precio a inventario no se puede cambiar la unidad sin convertirlo.
                  onChanged: widget.devolverPrecio
                      ? null
                      : (v) => setState(() => _unidad = v!),
                ),
                const SizedBox(height: 20),
                Text('Margen de ganancia: ${_margen.round()}%'),
                Slider(
                  value: _margen,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '${_margen.round()}%',
                  onChanged: (v) => setState(() => _margen = v),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
