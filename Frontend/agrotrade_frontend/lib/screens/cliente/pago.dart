import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'entrega.dart';
import 'resumenConfirmacion.dart';

enum _MetodoPago { tarjeta, transferencia, billetera }

class PagoScreen extends StatefulWidget {
  const PagoScreen({super.key});

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  _MetodoPago _metodo = _MetodoPago.tarjeta;
  bool _guardarMetodo = true;

  final _numeroCtrl = TextEditingController(text: '•••• •••• •••• 4242');
  final _titularCtrl = TextEditingController(text: 'María López');
  final _vencCtrl = TextEditingController(text: '12/28');
  final _cvvCtrl = TextEditingController(text: '•••');

  static const double _subtotal = 106.00;
  static const double _entrega = 40.00;
  static double get _total => _subtotal + _entrega;

  @override
  void dispose() {
    _numeroCtrl.dispose();
    _titularCtrl.dispose();
    _vencCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
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
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EntregaScreen()),
            );
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
            onTap: () => setState(() => _metodo = tipo),
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
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: appInputDecoration(
            hint: '•••• •••• •••• ••••',
            suffixIcon: const Icon(
              Icons.credit_card_outlined,
              color: AppColors.TextSoft,
              size: 20,
            ),
          ),
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

        // Vencimiento + CVV
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
                    decoration: appInputDecoration(hint: 'MM/AA'),
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
          onTap: () => setState(() => _guardarMetodo = !_guardarMetodo),
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
      child: Row(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResumenConfirmacionScreen(),
                    ),
                  );
                },
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
