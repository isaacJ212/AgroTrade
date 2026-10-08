import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'resumenConfirmacion.dart';
import '../../services/cart_service.dart';
import '../../services/payment_method_service.dart';
import '../../models/payment_method.dart';

enum _MetodoPago { tarjeta, transferencia, billetera }

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  _MetodoPago _metodo = _MetodoPago.tarjeta;
  bool _guardarMetodo = true;

  final _numeroCtrl = TextEditingController();
  final _titularCtrl = TextEditingController();
  final _vencCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  String _tipoTarjeta = '';

  List<PaymentMethod> _metodosGuardados = [];
  PaymentMethod? _metodoSeleccionado;
  bool _cargandoMetodos = true;

  @override
  void initState() {
    super.initState();
    print('DEBUG [PagoScreen] initState - Iniciando pantalla de pago (consumidor compras)');
    _numeroCtrl.addListener(_detectarTarjeta);
    _cargarMetodosGuardados();
  }

  Future<void> _cargarMetodosGuardados() async {
    try {
      print('DEBUG [PagoScreen] _cargarMetodosGuardados()');
      final metodos = await PaymentMethodService.instance.getAll();
      final predeterminado = await PaymentMethodService.instance.getDefault();
      if (!mounted) return;
      setState(() {
        _metodosGuardados = metodos;
        _cargandoMetodos = false;
        if (predeterminado != null) {
          print('DEBUG [PagoScreen] Autocompletando con método predeterminado: ${predeterminado.titular ?? predeterminado.tipo}');
          _seleccionarMetodoGuardado(predeterminado);
        } else {
          print('DEBUG [PagoScreen] No hay método predeterminado. Formulario vacío.');
        }
      });
    } catch (e) {
      print('DEBUG [PagoScreen] ERROR en _cargarMetodosGuardados: $e');
      if (mounted) {
        setState(() => _cargandoMetodos = false);
      }
    }
  }

  void _seleccionarMetodoGuardado(PaymentMethod m) {
    print('DEBUG [PagoScreen] _seleccionarMetodoGuardado: ${m.tipo} - ${m.titular ?? '-'}');
    setState(() {
      _metodoSeleccionado = m;
      if (m.tipo == 'tarjeta') {
        _metodo = _MetodoPago.tarjeta;
        _numeroCtrl.text = m.numeroTarjeta ?? '';
        _titularCtrl.text = m.titular ?? '';
        _vencCtrl.text = m.vencimiento ?? '';
        _cvvCtrl.text = m.cvv ?? '';
        _tipoTarjeta = m.tipoTarjeta ?? '';
      } else if (m.tipo == 'transferencia') {
        _metodo = _MetodoPago.transferencia;
      } else {
        _metodo = _MetodoPago.billetera;
      }
    });
  }

  String _generarId() => 'pm_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

  void _detectarTarjeta() {
    String num = _numeroCtrl.text.replaceAll(' ', '');
    String tipo = '';
    if (num.startsWith('4')) {
      tipo = 'VISA';
    } else if (num.startsWith('5')) {
      tipo = 'MASTERCARD';
    } else if (num.startsWith('3')) {
      tipo = 'AMEX';
    }
    if (_tipoTarjeta != tipo) {
      setState(() => _tipoTarjeta = tipo);
    }
  }

  double get _subtotal => CartService.instance.subtotalProductos;
  static const double _entrega = 40.00;
  double get _total => _subtotal + _entrega;

  @override
  void dispose() {
    print('DEBUG [PagoScreen] dispose()');
    _numeroCtrl.removeListener(_detectarTarjeta);
    _numeroCtrl.dispose();
    _titularCtrl.dispose();
    _vencCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  bool _isLuhnValid(String number) {
    if (number.isEmpty || int.tryParse(number) == null) return false;
    int sum = 0;
    bool isAlternate = false;
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);
      if (isAlternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      isAlternate = !isAlternate;
    }
    return sum % 10 == 0;
  }

  Future<void> _guardarMetodoSiAplica() async {
    if (!_guardarMetodo) {
      print('DEBUG [PagoScreen] _guardarMetodoSiAplica: Check NO marcado. Saltando guardado.');
      return;
    }
    print('DEBUG [PagoScreen] _guardarMetodoSiAplica: Check SI marcado. Procesando...');

    PaymentMethod? nuevo;
    final cleanNum = _numeroCtrl.text.replaceAll(' ', '');

    if (_metodo == _MetodoPago.tarjeta && cleanNum.isNotEmpty) {
      final ultimos4 = cleanNum.length >= 4 ? cleanNum.substring(cleanNum.length - 4) : cleanNum;
      final existe = _metodosGuardados.any((m) =>
          m.tipo == 'tarjeta' &&
          m.ultimos4 == ultimos4 &&
          m.titular?.toLowerCase() == _titularCtrl.text.trim().toLowerCase());
      if (existe) {
        print('DEBUG [PagoScreen] Tarjeta ya existe (últ4=$ultimos4, titular=${_titularCtrl.text}). No se duplica.');
      } else {
        nuevo = PaymentMethod(
          id: _generarId(),
          tipo: 'tarjeta',
          numeroTarjeta: _numeroCtrl.text.trim(),
          ultimos4: ultimos4,
          titular: _titularCtrl.text.trim(),
          vencimiento: _vencCtrl.text.trim(),
          cvv: _cvvCtrl.text.trim(),
          tipoTarjeta: _tipoTarjeta,
          esPredeterminado: _metodosGuardados.isEmpty,
          fechaGuardado: DateTime.now(),
        );
        print('DEBUG [PagoScreen] Nueva TARJETA detectada: $_tipoTarjeta **** $ultimos4');
      }
    } else if (_metodo == _MetodoPago.transferencia) {
      final existe = _metodosGuardados.any((m) => m.tipo == 'transferencia');
      if (existe) {
        print('DEBUG [PagoScreen] Transferencia ya guardada. No duplica.');
      } else {
        nuevo = PaymentMethod(
          id: _generarId(),
          tipo: 'transferencia',
          titular: 'Transferencia Bancaria',
          esPredeterminado: _metodosGuardados.isEmpty,
          fechaGuardado: DateTime.now(),
        );
        print('DEBUG [PagoScreen] Nueva TRANSFERENCIA a guardar.');
      }
    } else if (_metodo == _MetodoPago.billetera) {
      final existe = _metodosGuardados.any((m) => m.tipo == 'billetera');
      if (existe) {
        print('DEBUG [PagoScreen] Billetera ya guardada. No duplica.');
      } else {
        nuevo = PaymentMethod(
          id: _generarId(),
          tipo: 'billetera',
          titular: 'Billetera Digital',
          esPredeterminado: _metodosGuardados.isEmpty,
          fechaGuardado: DateTime.now(),
        );
        print('DEBUG [PagoScreen] Nueva BILLETERA a guardar.');
      }
    }

    if (nuevo != null) {
      try {
        await PaymentMethodService.instance.save(nuevo!);
        print('DEBUG [PagoScreen] Método guardado EXITOSAMENTE en storage.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Método de pago guardado ✓'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print('DEBUG [PagoScreen] ERROR al guardar método: $e');
      }
    }
  }

  Future<void> _validarYContinuar() async {
    print('DEBUG [PagoScreen] _validarYContinuar - Método: $_metodo, guardar=$_guardarMetodo');

    if (_metodo == _MetodoPago.tarjeta) {
      String num = _numeroCtrl.text.replaceAll(' ', '').replaceAll('-', '');
      if (num.isEmpty || _titularCtrl.text.isEmpty || _vencCtrl.text.isEmpty || _cvvCtrl.text.isEmpty) {
        print('DEBUG [PagoScreen] Validación FALLÓ: campos vacíos.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Por favor, completa todos los datos de la tarjeta.'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      if (!_isLuhnValid(num)) {
        print('DEBUG [PagoScreen] Validación FALLÓ: Luhn inválido.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El número de tarjeta no es válido (Fallo en Algoritmo de Luhn).'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      print('DEBUG [PagoScreen] Validación tarjeta OK (Luhn pasó).');
    }

    await _guardarMetodoSiAplica();

    if (!mounted) {
      print('DEBUG [PagoScreen] Widget ya no está montado. Cancelando navegación.');
      return;
    }
    print('DEBUG [PagoScreen] Navegando a ResumenConfirmacionScreen...');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResumenConfirmacionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStepper(),
          const Divider(height: 1, color: Color(0xFFE4E7E5)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Método de pago',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMetodoSelector(),
                  const SizedBox(height: 24),

                  _buildMetodosGuardados(),
                  if (_cargandoMetodos || _metodosGuardados.isNotEmpty) const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _buildPanel(),
                  ),

                  const SizedBox(height: 28),

                  _buildResumen(),
                  const SizedBox(height: 24),
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
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: const Text(
        'Pago',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _StepCircle(label: 'Carrito', done: true, active: false),
          _StepLine(done: true),
          _StepCircle(label: 'Entrega', done: true, active: false),
          _StepLine(done: true),
          _StepCircle(label: 'Pago', done: false, active: true, number: 3),
          _StepLine(done: false),
          _StepCircle(label: 'Conf.', done: false, active: false, number: 4),
        ],
      ),
    );
  }

  Widget _buildMetodoSelector() {
    const metodos = [
      (_MetodoPago.tarjeta, Icons.credit_card_outlined, 'Tarjeta'),
      (
        _MetodoPago.transferencia,
        Icons.account_balance_outlined,
        'Transferencia',
      ),
      (
        _MetodoPago.billetera,
        Icons.account_balance_wallet_outlined,
        'Billetera',
      ),
    ];

    return Row(
      children: metodos.map((m) {
        final (tipo, icon, label) = m;
        final bool sel = _metodo == tipo;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              print('DEBUG [PagoScreen] Método seleccionado: $label');
              setState(() => _metodo = tipo);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: sel ? AppColors.primarySoftBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: sel ? AppColors.primaryColor : const Color(0xFFCDD5D1),
                  width: sel ? 1.8 : 1.2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 22,
                        color: sel
                            ? AppColors.primaryColor
                            : AppColors.TextSoft,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel
                              ? AppColors.primaryColor
                              : AppColors.TextSoft,
                        ),
                      ),
                    ],
                  ),
                  if (sel)
                    Positioned(
                      top: -8,
                      right: 4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetodosGuardados() {
    if (_cargandoMetodos) {
      return const Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor)),
      ));
    }
    if (_metodosGuardados.isEmpty) return const SizedBox.shrink();

    final mostrar = _metodosGuardados.where((m) {
      if (_metodo == _MetodoPago.tarjeta) return m.tipo == 'tarjeta';
      if (_metodo == _MetodoPago.transferencia) return m.tipo == 'transferencia';
      return m.tipo == 'billetera';
    }).toList();

    if (mostrar.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.bookmark_outline_rounded, size: 16, color: AppColors.primaryColor),
            SizedBox(width: 6),
            Text(
              'Métodos guardados (toca para autocompletar)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...mostrar.map((m) => _buildTarjetaGuardadaTile(m)),
      ],
    );
  }

  Widget _buildTarjetaGuardadaTile(PaymentMethod m) {
    final bool sel = _metodoSeleccionado?.id == m.id;
    String subtitulo = '';
    IconData icono = Icons.credit_card_outlined;

    if (m.tipo == 'tarjeta') {
      subtitulo = '${m.tipoTarjeta?.isNotEmpty == true ? m.tipoTarjeta! + '  •  ' : ''}${m.maskedNumber}${m.vencimiento?.isNotEmpty == true ? '  •  Vence ' + m.vencimiento! : ''}';
      icono = Icons.credit_card_outlined;
    } else if (m.tipo == 'transferencia') {
      subtitulo = 'Transferencia bancaria LAFISE';
      icono = Icons.account_balance_outlined;
    } else {
      subtitulo = 'Billetera digital';
      icono = Icons.account_balance_wallet_outlined;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _seleccionarMetodoGuardado(m);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✓ Datos autocompletados'), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: sel ? AppColors.primarySoftBg : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: sel ? AppColors.primaryColor : AppColors.cardBorder,
                width: sel ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primaryColor.withOpacity(0.15) : AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icono, color: sel ? AppColors.primaryColor : AppColors.TextSoft, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              m.titular ?? m.tipo,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: sel ? AppColors.primaryColor : AppColors.titleDark, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          if (m.esPredeterminado) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                              child: const Text('Predet.', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primaryColor)),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(subtitulo, style: const TextStyle(fontSize: 12, color: AppColors.TextSoft)),
                    ],
                  ),
                ),
                if (sel) const Icon(Icons.check_circle, color: AppColors.primaryColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    switch (_metodo) {
      case _MetodoPago.tarjeta:
        return _buildPanelTarjeta();
      case _MetodoPago.transferencia:
        return _buildPanelTransferencia();
      case _MetodoPago.billetera:
        return _buildPanelBilletera();
    }
  }

  Widget _buildPanelTarjeta() {
    return Column(
      key: const ValueKey('tarjeta'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CampoLabel(label: 'Número de tarjeta'),
        const SizedBox(height: 6),
        TextField(
          controller: _numeroCtrl,
          keyboardType: TextInputType.number,
          maxLength: 19,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
            _CardNumberFormatter(),
          ],
          decoration: appInputDecoration(
            hint: '•••• •••• •••• ••••',
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_tipoTarjeta.isNotEmpty)
                    Text(
                      _tipoTarjeta,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                      ),
                    )
                  else
                    const Icon(Icons.credit_card_outlined, color: AppColors.TextSoft, size: 20),
                ],
              ),
            ),
          ).copyWith(counterText: ''),
        ),
        const SizedBox(height: 14),

        _CampoLabel(label: 'Titular de la tarjeta'),
        const SizedBox(height: 6),
        TextField(
          controller: _titularCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: appInputDecoration(hint: 'Como aparece en la tarjeta'),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CampoLabel(label: 'Vencimiento'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _vencCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                      _DateFormatter(),
                    ],
                    decoration: appInputDecoration(hint: 'MM/AA').copyWith(counterText: ''),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CampoLabel(label: 'CVV'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _cvvCtrl,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: appInputDecoration(
                      hint: '•••',
                      suffixIcon: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.TextSoft,
                        size: 18,
                      ),
                    ).copyWith(counterText: ''),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        GestureDetector(
          onTap: () {
            print('DEBUG [PagoScreen] Check guardar método: $_guardarMetodo -> ${!_guardarMetodo}');
            setState(() => _guardarMetodo = !_guardarMetodo);
          },
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _guardarMetodo ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: _guardarMetodo
                        ? AppColors.primaryColor
                        : AppColors.inputBorderColor,
                    width: 1.5,
                  ),
                ),
                child: _guardarMetodo
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              const Text(
                'Guardar este método de pago',
                style: TextStyle(fontSize: 14, color: AppColors.TextMain),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPanelTransferencia() {
    return Container(
      key: const ValueKey('transferencia'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Datos bancarios',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 12),
          _FilaBanco(label: 'Banco', valor: 'LAFISE Nicaragua'),
          const SizedBox(height: 8),
          _FilaBanco(label: 'Cuenta', valor: '1234-5678-9012'),
          const SizedBox(height: 8),
          _FilaBanco(label: 'Titular', valor: 'AgroTrade S.A.'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.amberSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Sube el comprobante en el siguiente paso.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.warning,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              print('DEBUG [PagoScreen] Check guardar método (transferencia): $_guardarMetodo -> ${!_guardarMetodo}');
              setState(() => _guardarMetodo = !_guardarMetodo);
            },
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: _guardarMetodo ? AppColors.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: _guardarMetodo ? AppColors.primaryColor : AppColors.inputBorderColor,
                      width: 1.5,
                    ),
                  ),
                  child: _guardarMetodo ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                ),
                const SizedBox(width: 10),
                const Text('Guardar este método de pago', style: TextStyle(fontSize: 14, color: AppColors.TextMain)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelBilletera() {
    return Container(
      key: const ValueKey('billetera'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 22,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Paga directamente desde tu billetera digital. '
                  'Serás redirigido para completar el pago.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primarySoft,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              print('DEBUG [PagoScreen] Check guardar método (billetera): $_guardarMetodo -> ${!_guardarMetodo}');
              setState(() => _guardarMetodo = !_guardarMetodo);
            },
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: _guardarMetodo ? AppColors.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: _guardarMetodo ? AppColors.primaryColor : AppColors.inputBorderColor,
                      width: 1.5,
                    ),
                  ),
                  child: _guardarMetodo ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                ),
                const SizedBox(width: 10),
                const Text('Guardar este método de pago', style: TextStyle(fontSize: 14, color: AppColors.TextMain)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RESUMEN DE COSTOS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.TextSoft,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _FilaResumen(
                label: 'Productos',
                valor: 'C\$${_subtotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 10),
              _FilaResumen(
                label: 'Entrega',
                valor: 'C\$${_entrega.toStringAsFixed(2)}',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.cardBorder),
              ),
              Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'C\$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _validarYContinuar,
                icon: const SizedBox.shrink(),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Volver a entrega',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String label;
  final bool done;
  final bool active;
  final int? number;

  const _StepCircle({
    required this.label,
    required this.done,
    required this.active,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
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
                  '${number ?? ''}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : const Color(0xFF6B7775),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
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
  }
}

class _StepLine extends StatelessWidget {
  final bool done;
  const _StepLine({required this.done});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: done ? AppColors.primaryColor : const Color(0xFFCDD5D1),
      ),
    );
  }
}

class _CampoLabel extends StatelessWidget {
  final String label;
  const _CampoLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.TextMain,
      ),
    );
  }
}

class _FilaBanco extends StatelessWidget {
  final String label;
  final String valor;
  const _FilaBanco({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.TextSoft),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.titleDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilaResumen extends StatelessWidget {
  final String label;
  final String valor;
  const _FilaResumen({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppColors.TextSoft),
        ),
        const Spacer(),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.titleDark,
          ),
        ),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.isEmpty) return newValue;
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if ((i + 1) % 4 == 0 && (i + 1) != newText.length) {
        buffer.write(' ');
      }
    }
    String formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('/', '');
    if (newText.isEmpty) return newValue;
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 1 && newText.length > 2) {
        buffer.write('/');
      }
    }
    String formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
