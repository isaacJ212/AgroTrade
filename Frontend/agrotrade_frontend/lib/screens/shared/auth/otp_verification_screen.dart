import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../ui/app_theme.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String title;
  final String description;
  final Duration validity;
  final Future<bool> Function(String code)? onVerify;
  final Future<void> Function()? onResend;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.title = 'Verificar código',
    this.description = 'Ingresa el código de verificación enviado a',
    this.validity = const Duration(minutes: 15),
    this.onVerify,
    this.onResend,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Duration _remaining;
  Timer? _timer;
  String _code = '';
  String? _error;
  bool _busy = false;
  Key _otpInputKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _remaining = widget.validity;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  String get _formattedTime {
    final minutes = _remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _verify() async {
    if (_remaining == Duration.zero) {
      setState(() => _error = 'El código expiró. Solicita uno nuevo.');
      return;
    }
    if (_code.length != 6) {
      setState(() => _error = 'Ingresa los 6 dígitos del código.');
      return;
    }
    if (widget.onVerify == null) {
      setState(
        () => _error = 'La verificación aún no está conectada al servidor.',
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final verified = await widget.onVerify!(_code);
      if (!mounted) return;
      if (!verified) {
        setState(() => _error = 'El código ingresado no es válido.');
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    if (_busy || widget.onResend == null) {
      setState(
        () => _error = 'No se puede reenviar el código en este momento.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onResend!();
      if (!mounted) return;
      setState(() {
        _remaining = widget.validity;
        _code = '';
        _otpInputKey = UniqueKey();
      });
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se envió un nuevo código.')),
      );
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: '${widget.description} ',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.TextSoft,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.TextMain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              OtpCodeInput(
                key: _otpInputKey,
                onChanged: (value) => setState(() {
                  _code = value;
                  _error = null;
                }),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    expired ? Icons.timer_off_outlined : Icons.timer_outlined,
                    size: 18,
                    color: expired
                        ? AppColors.errorColor
                        : AppColors.primaryColor,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    expired
                        ? 'Código expirado'
                        : 'El código expira en $_formattedTime',
                    style: TextStyle(
                      color: expired
                          ? AppColors.errorColor
                          : AppColors.TextSoft,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.errorColor),
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _busy || expired ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Verificar'),
                ),
              ),
              if (widget.onResend != null) ...[
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: _busy ? null : _resend,
                    child: Text(
                      expired
                          ? 'Solicitar un nuevo código'
                          : '¿No recibiste el código? Reenviar',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OtpCodeInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const OtpCodeInput({super.key, required this.onChanged});

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
  static const int _length = 6;
  final List<TextEditingController> _controllers = List.generate(
    _length,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _length,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _updateFrom(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 1) {
      var cursor = index;
      for (final digit in digits.split('')) {
        if (cursor >= _length) break;
        _controllers[cursor].value = TextEditingValue(
          text: digit,
          selection: const TextSelection.collapsed(offset: 1),
        );
        cursor++;
      }
      final next = cursor.clamp(0, _length - 1).toInt();
      _focusNodes[next].requestFocus();
    } else {
      _controllers[index].value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
      if (digits.isNotEmpty && index < _length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else if (digits.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    widget.onChanged(_controllers.map((controller) => controller.text).join());
    setState(() {});
  }

  KeyEventResult _handleKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(_length, (index) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: index == _length - 1 ? 0 : 7),
          child: Focus(
            onKeyEvent: (_, event) => _handleKey(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.TextMain,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => _updateFrom(index, value),
            ),
          ),
        ),
      );
    }),
  );
}
