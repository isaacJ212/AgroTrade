import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/components.dart';
import '../../../../services/users_api_service.dart';
import 'otp_verification_screen.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _emailController = TextEditingController();

  String? _emailError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validate() {
    final String text = _emailController.text.trim();
    bool esValido = true;
    setState(() {
      _emailError = null;
    });

    if (text.isEmpty) {
      esValido = false;
      _emailError = "Correo Es Obligatorio";
    } else if (!text.contains("@") || !text.contains(".")) {
      esValido = false;
      _emailError = "Correo Invalido";
    }

    return esValido;
  }

  Future<void> _enviarInstrucciones() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    final email = _emailController.text.trim();
    setState(() => _isLoading = true);
    try {
      await UsersApiService.instance.sendPasswordRecoveryCode(email: email);
      if (!mounted) return;

      final verified = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => OtpVerificationScreen(
            email: email,
            title: 'Recupera tu contraseña',
            description: 'Ingresa el código de 6 dígitos enviado a',
            validity: const Duration(minutes: 10),
            onVerify: (code) async {
              await UsersApiService.instance.verifyPasswordRecoveryCode(
                email: email,
                code: code,
              );
              return true;
            },
            onResend: () =>
                UsersApiService.instance.sendPasswordRecoveryCode(email: email),
          ),
        ),
      );
      if (!mounted || verified != true) return;

      final reset = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _RecoveryNewPasswordDialog(email: email),
      );
      if (reset == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña se restableció correctamente.'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _volverLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySoftBg,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.history_rounded,
                                  color: AppColors.primaryColor,
                                  size: 26,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              "Recuperar contraseña",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.Title,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Ingresa tu correo electrónico y te enviaremos instrucciones para restablecer tu contraseña.",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.SubTitle,
                            ),
                            const SizedBox(height: 24),

                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_) =>
                                  setState(() => _emailError = null),
                              decoration: appInputDecoration(
                                hint: "Correo electrónico",
                              ).copyWith(errorText: _emailError),
                            ),
                            const SizedBox(height: 20),

                            PrimaryButton(
                              label: _isLoading
                                  ? "Enviando código..."
                                  : "Enviar Instrucciones",
                              radius: 10,
                              onPressed: _isLoading
                                  ? null
                                  : _enviarInstrucciones,
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: _volverLogin,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.accentBlue,
                                  side: const BorderSide(
                                    color: AppColors.inputBorderColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Volver al inicio de sesión",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RecoveryNewPasswordDialog extends StatefulWidget {
  final String email;

  const _RecoveryNewPasswordDialog({required this.email});

  @override
  State<_RecoveryNewPasswordDialog> createState() =>
      _RecoveryNewPasswordDialogState();
}

class _RecoveryNewPasswordDialogState
    extends State<_RecoveryNewPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _saving = false;
  String? _serverError;

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _serverError = null;
    });

    try {
      await UsersApiService.instance.resetPasswordByRecoveryCode(
        email: widget.email,
        newPassword: _password.text,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        setState(
          () => _serverError = error.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Nueva contraseña', style: AppTextStyles.Title),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Crea una contraseña nueva de al menos 8 caracteres.'),
            const SizedBox(height: 16),
            _passwordField(
              controller: _password,
              label: 'Nueva contraseña',
              validator: (value) => value == null || value.length < 8
                  ? 'Usa al menos 8 caracteres.'
                  : null,
            ),
            const SizedBox(height: 12),
            _passwordField(
              controller: _confirmation,
              label: 'Confirmar contraseña',
              validator: (value) => value != _password.text
                  ? 'Las contraseñas no coinciden.'
                  : null,
            ),
            if (_serverError != null) ...[
              const SizedBox(height: 12),
              Text(
                _serverError!,
                style: const TextStyle(color: AppColors.errorColor),
              ),
            ],
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(false),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        style: FilledButton.styleFrom(backgroundColor: AppColors.primaryColor),
        child: _saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Guardar'),
      ),
    ],
  );

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) => TextFormField(
    controller: controller,
    obscureText: true,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
