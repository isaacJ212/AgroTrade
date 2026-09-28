import 'package:flutter/material.dart';

import '../../models/api/user_models.dart';
import '../../services/api_session.dart';
import '../../services/users_api_service.dart';
import '../../ui/app_theme.dart';
import 'auth/otp_verification_screen.dart';

Future<void> showChangePasswordDialog(BuildContext context) async {
  final userId = int.tryParse(ApiSession.instance.userId ?? '');
  if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No se pudo identificar la cuenta. Inicia sesión nuevamente.',
        ),
      ),
    );
    return;
  }

  final sent = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        _PasswordOtpNoticeDialog(email: ApiSession.instance.userEmail),
  );
  if (sent != true || !context.mounted) return;

  final verified = await Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      builder: (_) => OtpVerificationScreen(
        email: ApiSession.instance.userEmail ?? 'tu correo registrado',
        title: 'Verifica tu identidad',
        description: 'Ingresa el código de 6 dígitos enviado a',
        onVerify: (code) async {
          await UsersApiService.instance.verifyPasswordCode(
            userId: userId,
            code: code,
          );
          return true;
        },
      ),
    ),
  );
  if (verified != true || !context.mounted) return;

  final changed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ChangePasswordDialog(userId: userId),
  );
  if (changed == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La contraseña se actualizó correctamente.'),
      ),
    );
  }
}

class _PasswordOtpNoticeDialog extends StatelessWidget {
  final String? email;
  const _PasswordOtpNoticeDialog({this.email});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Verificación por correo', style: AppTextStyles.Title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'El código de 6 dígitos se genera y envía automáticamente por el '
          'backend. Ingresa el código recibido para continuar; vence en 5 minutos:',
        ),
        const SizedBox(height: 8),
        Text(
          email ?? 'Correo de la cuenta',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: FilledButton.styleFrom(backgroundColor: AppColors.primaryColor),
        child: const Text('Ingresar código'),
      ),
    ],
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  final int userId;
  const _ChangePasswordDialog({required this.userId});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmation = TextEditingController();
  bool _saving = false;
  String? _serverError;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
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
      await UsersApiService.instance.updatePassword(
        userId: widget.userId,
        dto: UpdatePasswordRequestDto(
          currentPassword: _currentPassword.text,
          newPassword: _newPassword.text,
        ),
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
    backgroundColor: Colors.white,
    title: const Text('Cambiar contraseña', style: AppTextStyles.Title),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Confirma tu contraseña actual y escribe una nueva.'),
            const SizedBox(height: 18),
            _passwordField(
              controller: _currentPassword,
              label: 'Contraseña actual',
              validator: (value) => value == null || value.isEmpty
                  ? 'Ingresa tu contraseña actual.'
                  : null,
            ),
            const SizedBox(height: 12),
            _passwordField(
              controller: _newPassword,
              label: 'Nueva contraseña',
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Usa al menos 8 caracteres.';
                }
                if (value == _currentPassword.text) {
                  return 'Debe ser distinta a la contraseña actual.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _passwordField(
              controller: _confirmation,
              label: 'Confirmar nueva contraseña',
              validator: (value) => value != _newPassword.text
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
