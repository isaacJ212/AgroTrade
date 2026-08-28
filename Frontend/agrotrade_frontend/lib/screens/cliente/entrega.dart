import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

class _Direccion {
  final String alias;
  final String ciudad;
  final String detalle;

  const _Direccion({
    required this.alias,
    required this.ciudad,
    required this.detalle,
  });
}

class EntregaScreen extends StatefulWidget {
  const EntregaScreen({super.key});

  @override
  State<EntregaScreen> createState() => _EntregaScreenState();
}

class _EntregaScreenState extends State<EntregaScreen> {
  bool _entregaDomicilio = true;

  final List<_Direccion> _direcciones = const [
    _Direccion(
      alias: 'Casa',
      ciudad: 'Jinotepe, Carazo',
      detalle: 'Barrio San Felipe, De la iglesia 2c al sur',
    ),
  ];

  int _selDireccion = 0;

  final TextEditingController _indicacionesCtrl = TextEditingController();

  @override
  void dispose() {
    _indicacionesCtrl.dispose();
    super.dispose();
  }

  void _agregarDireccion() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Agregar nueva dirección (próximamente)'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _editarDireccion(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar "${_direcciones[index].alias}" (próximamente)'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _continuarAlPago() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Continuando al pago…'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const _CheckoutStepper(currentStep: 1),
          const Divider(height: 1, color: Color(0xFFE4E7E5)),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pregunta principal
                  const Text(
                    '¿Cómo querés recibir tu pedido?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Opciones de método
                  _MetodoEntregaTile(
                    selected: _entregaDomicilio,
                    icon: Icons.local_shipping_outlined,
                    label: 'Entrega a domicilio',
                    onTap: () => setState(() => _entregaDomicilio = true),
                  ),
                  const SizedBox(height: 10),
                  _MetodoEntregaTile(
                    selected: !_entregaDomicilio,
                    icon: Icons.storefront_outlined,
                    label: 'Retiro en finca',
                    onTap: () => setState(() => _entregaDomicilio = false),
                  ),

                  // Sección de dirección (solo si eligió domicilio)
                  if (_entregaDomicilio) ...[
                    const SizedBox(height: 28),
                    _buildDireccionSection(),
                  ],

                  const SizedBox(height: 28),

                  // Indicaciones
                  _buildIndicacionesSection(),

                  const SizedBox(height: 20),

                  // Aviso de costo
                  _buildAvisoCosto(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          _buildFooter(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Entrega',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.titleDark,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildDireccionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        Row(
          children: [
            const Text(
              'DIRECCIÓN DE ENTREGA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.TextSoft,
                letterSpacing: 0.8,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _agregarDireccion,
              child: Row(
                children: const [
                  Icon(Icons.add, size: 16, color: AppColors.primaryColor),
                  SizedBox(width: 2),
                  Text(
                    'Nueva',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tarjetas de dirección
        ...List.generate(_direcciones.length, (i) {
          final d = _direcciones[i];
          final bool sel = _selDireccion == i;
          return _DireccionCard(
            direccion: d,
            selected: sel,
            onTap: () => setState(() => _selDireccion = i),
            onEdit: () => _editarDireccion(i),
          );
        }),
      ],
    );
  }

  Widget _buildIndicacionesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INDICACIONES PARA LA ENTREGA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.TextSoft,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _indicacionesCtrl,
          maxLines: 4,
          style: const TextStyle(fontSize: 14, color: AppColors.TextMain),
          decoration: InputDecoration(
            hintText: 'Ej. Casa de portón verde, timbre no funciona.',
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.chipGrey),
            contentPadding: const EdgeInsets.all(14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvisoCosto() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'El costo y tiempo estimado de entrega se calcularán según la ubicación de los productores.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primarySoft,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE4E7E5), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: 'Continuar al pago',
              radius: 100,
              onPressed: _continuarAlPago,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Text(
                  'Volver al carrito',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutStepper extends StatelessWidget {
  final int currentStep;

  const _CheckoutStepper({required this.currentStep});

  static const _steps = ['Carrito', 'Entrega', 'Pago', 'Conf.'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Línea conectora
            final stepIndex = i ~/ 2;
            final done = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: done ? AppColors.primaryColor : const Color(0xFFCDD5D1),
              ),
            );
          }

          final stepIndex = i ~/ 2;
          final done = stepIndex < currentStep;
          final active = stepIndex == currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Círculo
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active
                      ? AppColors.primaryColor
                      : const Color(0xFFCDD5D1),
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? Colors.white
                              : const Color(0xFF6B7775),
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              // Etiqueta
              Text(
                _steps[stepIndex],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: done || active
                      ? AppColors.primaryColor
                      : const Color(0xFF8F9F9A),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _MetodoEntregaTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MetodoEntregaTile({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoftBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primaryColor : const Color(0xFFCDD5D1),
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          children: [
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryColor
                      : const Color(0xFFAEB8B4),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Center(
                      child: Icon(Icons.circle, size: 8, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              size: 20,
              color: selected ? AppColors.primaryColor : AppColors.TextSoft,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primaryColor : AppColors.TextMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DireccionCard extends StatelessWidget {
  final _Direccion direccion;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _DireccionCard({
    required this.direccion,
    required this.selected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primaryColor : const Color(0xFFE1E3E4),
            width: selected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono casa
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.home_outlined,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    direccion.alias,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    direccion.ciudad,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.TextSoft,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    direccion.detalle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.TextSoft,
                    ),
                  ),
                ],
              ),
            ),
            // Botón editar
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColors.primaryColor,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
