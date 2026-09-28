import 'package:flutter/material.dart';
import '../../../../services/api_session.dart';
import '../../../../services/auth_api_service.dart';
import 'otp_verification_screen.dart';

class VerificarCodigo extends StatefulWidget {
  final String correo;
  final int? userId;
  final Future<bool> Function(String code)? onVerify;
  final Future<void> Function()? onResend;
  final String title;

  const VerificarCodigo({
    super.key,
    required this.correo,
    this.userId,
    this.onVerify,
    this.onResend,
    this.title = 'Verificar código',
  });

  @override
  State<VerificarCodigo> createState() => _VerificarCodigoState();
}

class _VerificarCodigoState extends State<VerificarCodigo> {
  @override
  Widget build(BuildContext context) {
    final userId =
        widget.userId ?? int.tryParse(ApiSession.instance.userId ?? '');
    final verify =
        widget.onVerify ??
        (userId == null
            ? null
            : (String code) async {
                await AuthApiService.instance.verifyCode(
                  userId: userId,
                  code: code,
                );
                return true;
              });
    return OtpVerificationScreen(
      email: widget.correo,
      title: widget.title,
      onVerify: verify,
      onResend: widget.onResend,
    );
  }
}
