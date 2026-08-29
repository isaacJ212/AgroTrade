import 'package:flutter/material.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../../../ui/widgets/app_dropdown.dart';
import '../inicioProductor.dart';
import 'resultadoPrecioJusto.dart';


class CalculadoraPrecioJusto extends StatefulWidget {

  final String? nombreProducto;

  const CalculadoraPrecioJusto({super.key, this.nombreProducto});

  @override
  State<CalculadoraPrecioJusto> createState() => _CalculadoraPrecioJustoState();
}

class _CalculadoraPrecioJustoState extends State<CalculadoraPrecioJusto> {
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();


  static const Map<String, String> _unidades = {
    'Kilogramos (kg)': 'kg',
    'Libras (lb)': 'libra',
    'Toneladas (t)': 'tonelada',
    'Cajas': 'caja',
    'Docenas': 'docena',
  };

  String _unidadLabel = 'Kilogramos (kg)';

  
  double _margen = 30;

  @override
  void dispose() {
    _costoController.dispose();
    _cantidadController.dispose();
    super.dispose();
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


  void _calcular() {
    final costoTotal = double.tryParse(_costoController.text);
    final cantidad = double.tryParse(_cantidadController.text);

    if (costoTotal == null || costoTotal <= 0) {
      return _mostrarSnack('Ingresa el costo total de producción');
    }
    if (cantidad == null || cantidad <= 0) {
      return _mostrarSnack('Ingresa la cantidad producida');
    }


    final costoPorUnidad = costoTotal / cantidad;
    final precioSugerido = costoPorUnidad * (1 + _margen / 100);


    final desglose = [
      {'icon': Icons.agriculture_outlined, 'label': 'Insumos y Semillas', 'value': costoPorUnidad * 0.45},
      {'icon': Icons.people_outline, 'label': 'Mano de Obra', 'value': costoPorUnidad * 0.35},
      {'icon': Icons.local_shipping_outlined, 'label': 'Transporte Estimado', 'value': costoPorUnidad * 0.12},
      {'icon': Icons.receipt_long_outlined, 'label': 'Otros Costos Operativos', 'value': costoPorUnidad * 0.08},
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoPrecioJusto(
          nombreProducto: widget.nombreProducto ?? 'Producto Agrícola',
          precioSugerido: double.parse(precioSugerido.toStringAsFixed(2)),
          costoTotal: double.parse(costoPorUnidad.toStringAsFixed(2)),
          margenGanancia: double.parse((precioSugerido - costoPorUnidad).toStringAsFixed(2)),
          unidad: _unidades[_unidadLabel] ?? 'kg',
          desglose: desglose,
        ),
      ),
    );
  }

  Future<void> _irATab(int index) async {
    if (index == 1) return;
    if (index == 0) {
      await Navigator.pushReplacement(
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _encabezado(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _cardCalculadora(),
                  const SizedBox(height: 16),
                 
                  const AccentInfoCard(
                    icon: Icons.info_outline,
                    title: '¿Qué es el Precio Justo AgroTrade?',
                    text:
                        'Nuestro algoritmo asegura que el productor cubra sus costos y obtenga un margen digno para reinvertir en sus tierras, promoviendo la sostenibilidad a largo plazo y prácticas agrícolas responsables. Los compradores pueden buscar este sello dorado en el mercado.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
          NavElemento(label: 'Mercado', icon: Icons.storefront_outlined, activeIcon: Icons.storefront),
          NavElemento(label: 'Mis Pedidos', icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: 1,
        onTap: _irATab,
      ),
    );
  }


  Widget _encabezado() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('AgroTrade',
              style: AppTextStyles.wordmark.copyWith(fontSize: 22)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications,
                    color: AppColors.titleDark, size: 22),
                onPressed: () => _mostrarSnack('Sin notificaciones nuevas'),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle,
                    color: AppColors.primaryColor, size: 26),
                onPressed: () => Navigator.pushNamed(context, '/productor/finca'),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _cardCalculadora() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
 
          Container(
            height: 6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.amber],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calculate,
                          color: AppColors.White, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Calculadora de Precio Justo',
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 20,
                          color: AppColors.primarySoft,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Asegure la rentabilidad de su cosecha. Esta herramienta le ayuda a calcular un precio de venta recomendado basándose en sus costos reales y un margen de beneficio estándar del sector agropecuario, fomentando un comercio transparente y equitativo.',
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 13,
                    color: AppColors.bodyText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                _labelCampo('Costo total de producción'),
                const SizedBox(height: 8),
                _campo(
                  controller: _costoController,
                  hint: '0.00',
                  icon: Icons.payments_outlined,
                  suffix: 'USD',
                  keyboard: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 6),
                Text(
                  'Incluya insumos, labor, transporte y otros gastos operativos directos.',
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 14),

              
                _labelCampo('Cantidad'),
                const SizedBox(height: 8),
                _campo(
                  controller: _cantidadController,
                  hint: 'Ej. 100',
                  keyboard: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 14),

               
                AppDropdown<String>(
                  label: 'Unidad de medida',
                  value: _unidadLabel,
                  items: _unidades.keys.toList(),
                  itemLabel: (e) => e,
                  onChanged: (v) => setState(() => _unidadLabel = v!),
                ),
                const SizedBox(height: 14),

                
                _cajaMargen(),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 16),

             
                PrimaryButton(
                  label: 'Calcular Precio Justo',
                  icon: Icons.bar_chart,
                  radius: 12,
                  onPressed: _calcular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _labelCampo(String texto) {
    return Text(
      texto,
      style: AppTextStyles.label.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.titleDark,
      ),
    );
  }


  Widget _campo({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? suffix,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,

        filled: true,
        fillColor: AppColors.screenBg,
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.bodyText, size: 20)
            : null,
        suffixText: suffix,
        suffixStyle: AppTextStyles.label.copyWith(
          color: AppColors.bodyText.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorderColor),
        ),
      ),
    );
  }


  Widget _cajaMargen() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navPill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primaryColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Margen de Beneficio Deseado',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
              ),
              Text(
                '${_margen.toInt()}%',
                style: AppTextStyles.productoTitle.copyWith(
                  fontSize: 20,
                  color: AppColors.primarySoft,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: AppColors.primaryColor,
              inactiveTrackColor: AppColors.White,
              thumbColor: AppColors.primaryColor,
              overlayColor: AppColors.primaryGlow,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _margen,
              min: 5,
              max: 100,
              divisions: 19, 
              onChanged: (v) => setState(() => _margen = v),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mínimo (5%)', style: AppTextStyles.SubTitle.copyWith(fontSize: 11)),
              Text('Recomendado (30%)', style: AppTextStyles.SubTitle.copyWith(fontSize: 11)),
              Text('Máximo (100%)', style: AppTextStyles.SubTitle.copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}