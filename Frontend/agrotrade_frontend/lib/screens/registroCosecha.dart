import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';
import '../ui/widgets/app_text_field.dart';
import '../ui/widgets/buttons.dart';
import 'inicioProductor.dart';


class RegistroCosecha extends StatefulWidget {
  const RegistroCosecha({super.key});
  @override
  State<RegistroCosecha> createState() => _RegistroCosechaState();
}

class _RegistroCosechaState extends State<RegistroCosecha> {
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  DateTime? _fechaCosecha;
  bool _disponibleEnMercado = true;
  static const double _margenEtico = 0.30;

  @override
  void dispose() {
    _cantidadController.dispose();
    _fechaController.dispose();
    _costoController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  String get _fechaTexto {
    final f = _fechaCosecha;
    if (f == null) return '';
    String dos(int v) => v.toString().padLeft(2, '0');
    return '${dos(f.day)}/${dos(f.month)}/${f.year}';
  }

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _seleccionarFecha() async {
    final seleccion = await showDatePicker(
      context: context,
      initialDate: _fechaCosecha ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primaryColor),
        ),
        child: child!,
      ),
    );
    if (seleccion != null) {
      setState(() {
        _fechaCosecha = seleccion;
        _fechaController.text = _fechaTexto;
      });
    }
  }

  void _calcularPrecioJusto() {
    final costo = double.tryParse(_costoController.text);
    if (costo == null || costo <= 0) {
      return _mostrarSnack('Ingresa primero el costo de producción');
    }
    setState(() {
      _precioController.text = (costo * (1 + _margenEtico)).toStringAsFixed(2);
    });
    _mostrarSnack('Precio justo sugerido aplicado (margen 30%) ⚖️');
  }

  Future<void> _guardarInventario() async {
    final cantidad = double.tryParse(_cantidadController.text);
    final costo = double.tryParse(_costoController.text);
    final precio = double.tryParse(_precioController.text);

    if (cantidad == null || cantidad <= 0) return _mostrarSnack('Ingresa una cantidad válida');
    if (_fechaCosecha == null) return _mostrarSnack('Selecciona la fecha de cosecha');
    if (costo == null || costo <= 0) return _mostrarSnack('Ingresa el costo de producción');
    if (precio == null || precio <= 0) return _mostrarSnack('Ingresa el precio de venta');
    if (precio < costo) return _mostrarSnack('El precio no puede ser menor al costo');

    

    // Mostrar indicadoa
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
     
      await Future.delayed(const Duration(milliseconds: 500));

      

      if (!mounted) return;
      Navigator.of(context).pop(); // cerrar el dialo de carga
      _mostrarSnack('Inventario guardado con éxito 🌱');

    
    } catch (e, st) {
      if (mounted) Navigator.of(context).pop();
      _mostrarSnack('Error al guardar. Intenta de nuevo');
    }
  }

  void _irATab(int index) {
    if (index == 2) {
      Navigator.pop(context);
      return;
    }
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioProductor()),
      );
      return;
    }
    _mostrarSnack('Esta sección estará disponible pronto 🌱');
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
        titleSpacing: 0,
        title: Text('Registro de Cosecha',
            style: AppTextStyles.Title.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: AppColors.titleDark)),
        shape: const Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _CardSeccion(
            icon: Icons.eco,
            titulo: 'Detalles del Producto',
            children: [
              AppTextField(
                label: 'Cantidad disponible (kg)',
                hint: '0',
                controller: _cantidadController,
                keyboard: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Fecha de cosecha',
                hint: 'mm/dd/yyyy',
                controller: _fechaController,
                readOnly: true,
                onTap: _seleccionarFecha,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _CardSeccion(
            icon: Icons.payments_outlined,
            titulo: 'Costos y Precios',
            children: [
              AppTextField(
                label: 'Costo de producción (por kg)',
                hint: '0.00',
                prefix: '\$ ',
                controller: _costoController,
                keyboard: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Precio de venta (por kg)',
                hint: '0.00',
                prefix: '\$ ',
                controller: _precioController,
                keyboard: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              _calculadoraPrecioJusto(),
            ],
          ),
          const SizedBox(height: 14),
          _cardDisponibilidad(),
          const SizedBox(height: 20),

          PrimaryButton(
            label: 'Guardar inventario',
            icon: Icons.save_outlined,
            radius: 25,
            onPressed: _guardarInventario,
          ),
        ],
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
          NavElemento(label: 'Explorar', icon: Icons.explore_outlined, activeIcon: Icons.explore),
          NavElemento(label: 'Inventario', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: 2,
        onTap: _irATab,
      ),
    );
  }

  Widget _calculadoraPrecioJusto() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navPill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.scale_outlined, color: AppColors.amber, size: 18),
            SizedBox(width: 8),
            Text('Calculadora de Precio Justo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor)),
          ]),
          const SizedBox(height: 6),
          Text('Establece un margen ético basado en estándares del mercado.',
              style: AppTextStyles.SubTitle.copyWith(fontSize: 13,
                  color: AppColors.bodyText)),
          const SizedBox(height: 10),

          SecondaryButton(
            label: 'Calcular Precio Justo',
            color: AppColors.amber,
            textColor: AppColors.titleDark,
            onPressed: _calcularPrecioJusto,
          ),
        ],
      ),
    );
  }

  Widget _cardDisponibilidad() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Disponibilidad en Mercado',
                    style: AppTextStyles.productoTitle.copyWith(fontSize: 16)),
                const SizedBox(height: 6),
                Text('Publicar este inventario para que los compradores lo vean.',
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 13,
                        color: AppColors.bodyText)),
              ],
            ),
          ),
          Switch(
            value: _disponibleEnMercado,
            activeColor: AppColors.primarySoft,
            activeTrackColor: AppColors.primaryColor.withOpacity(0.4),
            onChanged: (v) => setState(() => _disponibleEnMercado = v),
          ),
        ],
      ),
    );
  }
}


class _CardSeccion extends StatelessWidget {
  final IconData? icon;
  final String titulo;
  final List<Widget> children;

  const _CardSeccion({this.icon, required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(titulo,
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 17))),
          ]),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}