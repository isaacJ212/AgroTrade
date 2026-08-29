import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../../../ui/widgets/app_dropdown.dart';

class CrearOferta extends StatefulWidget {
  const CrearOferta({super.key});

  @override
  State<CrearOferta> createState() => _CrearOfertaState();
}

class _CrearOfertaState extends State<CrearOferta> {
  final _cantidadController = TextEditingController();
  final _descuentoController = TextEditingController();
  final _fechaController = TextEditingController();

  String? _productoSeleccionado;
  bool _activarInmediatamente = true;

  final List<Map<String, dynamic>> _productos = [
    {'nombre': 'Tomate', 'precio': 25.00, 'unidad': 'libra'},
    {'nombre': 'Maíz', 'precio': 15.00, 'unidad': 'libra'},
    {'nombre': 'Frijol', 'precio': 45.00, 'unidad': 'libra'},
    {'nombre': 'Café', 'precio': 120.00, 'unidad': 'libra'},
    {'nombre': 'Aguacate', 'precio': 30.00, 'unidad': 'unidad'},
  ];

  double get _precioActual {
    if (_productoSeleccionado == null) return 0;
    final prod = _productos.firstWhere(
      (p) => p['nombre'] == _productoSeleccionado,
      orElse: () => {'precio': 0.0},
    );
    return (prod['precio'] as double);
  }

  String get _unidadActual {
    if (_productoSeleccionado == null) return 'unidad';
    final prod = _productos.firstWhere(
      (p) => p['nombre'] == _productoSeleccionado,
      orElse: () => {'unidad': 'unidad'},
    );
    return prod['unidad'] as String;
  }

  double get _descuento {
    return double.tryParse(_descuentoController.text) ?? 0;
  }

  double get _precioConDescuento {
    if (_descuento <= 0 || _precioActual <= 0) return _precioActual;
    return _precioActual * (1 - _descuento / 100);
  }

  @override
  void initState() {
    super.initState();
    _descuentoController.addListener(() => setState(() {}));
    _cantidadController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _descuentoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: hoy.add(const Duration(days: 7)),
      firstDate: hoy,
      lastDate: DateTime(hoy.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.White,
              surface: AppColors.White,
              onSurface: AppColors.titleDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _publicarOferta() {
    if (_productoSeleccionado == null) {
      return _mostrarSnack('Selecciona un producto');
    }
    if (_cantidadController.text.trim().isEmpty) {
      return _mostrarSnack('Ingresa la cantidad en excedente');
    }
    if (_descuentoController.text.trim().isEmpty || _descuento <= 0) {
      return _mostrarSnack('Ingresa un porcentaje de descuento válido');
    }
    if (_descuento >= 100) {
      return _mostrarSnack('El descuento no puede ser 100% o más');
    }
    if (_fechaController.text.trim().isEmpty) {
      return _mostrarSnack('Selecciona una fecha de finalización');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('¡Oferta publicada exitosamente!'),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    Navigator.pop(context);
  }

  void _guardarBorrador() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Borrador guardado'),
        backgroundColor: AppColors.bodyText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crear oferta',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.titleDark,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.cardBorder, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Configura un descuento para facilitar la venta de tu excedente',
                      style: AppTextStyles.SubTitle.copyWith(
                        color: AppColors.primarySoft,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            AppDropdown<String>(
              label: 'Producto',
              value: _productoSeleccionado,
              items: _productos.map((p) => p['nombre'] as String).toList(),
              itemLabel: (item) => item,
              hint: 'Selecciona un producto',
              onChanged: (val) => setState(() => _productoSeleccionado = val),
            ),
            const SizedBox(height: 16),

            Text(
              'Cantidad en excedente',
              style: AppTextStyles.label.copyWith(
                fontSize: 14,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cantidadController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: appInputDecoration(label: '', hint: '0').copyWith(
                suffix: Text(
                  _unidadActual,
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 13,
                    color: AppColors.bodyText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Precio actual',
              hint: _productoSeleccionado == null
                  ? 'C\$ 0.00'
                  : 'C\$ ${_precioActual.toStringAsFixed(2)}',
              controller: TextEditingController(
                text: _productoSeleccionado == null
                    ? ''
                    : 'C\$ ${_precioActual.toStringAsFixed(2)}',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),

            Text(
              'Descuento',
              style: AppTextStyles.label.copyWith(
                fontSize: 14,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descuentoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: appInputDecoration(label: '', hint: '0').copyWith(
                suffix: Text(
                  '%',
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'PRECIO CON DESCUENTO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'C\$ ${_precioConDescuento.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'por $_unidadActual',
                        style: AppTextStyles.SubTitle.copyWith(
                          color: AppColors.primarySoft,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Fecha de finalización',
              hint: 'DD/MM/AAAA',
              controller: _fechaController,
              readOnly: true,
              onTap: _seleccionarFecha,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activar oferta inmediatamente',
                          style: AppTextStyles.label.copyWith(
                            fontSize: 14,
                            color: AppColors.titleDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'El descuento será visible para los compradores.',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _activarInmediatamente,
                    onChanged: (val) =>
                        setState(() => _activarInmediatamente = val),
                    activeThumbColor: AppColors.White,
                    activeTrackColor: AppColors.primaryColor,
                    inactiveThumbColor: AppColors.White,
                    inactiveTrackColor: AppColors.chipGrey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 15,
                  color: AppColors.bodyText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'El descuento se aplicará únicamente durante el periodo configurado.',
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            PrimaryButton(
              label: 'Publicar oferta',
              radius: 25,
              onPressed: _publicarOferta,
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Guardar borrador',
              color: AppColors.primaryColor,
              textColor: AppColors.primaryColor,
              onPressed: _guardarBorrador,
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 10),
            TertiaryButton(label: 'Cancelar', onPressed: () {}),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
