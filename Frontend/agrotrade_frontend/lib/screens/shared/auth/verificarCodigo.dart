import 'package:flutter/material.dart';
import '../../../../ui/app_theme.dart';
import '../../../../ui/components.dart';

class VerificarCodigo extends StatefulWidget {
  final String correo;

  const VerificarCodigo({
    super.key,
    required this.correo,
  });

  @override
  State<VerificarCodigo> createState() => _VerificarCodigoState();
}

class _VerificarCodigoState extends State<VerificarCodigo> {
  final TextEditingController _codigoController = TextEditingController();
  String? _codigoError;

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  bool _validate() {
    final String text = _codigoController.text.trim();
    bool esValido = true;
    setState(() {
      _codigoError = null;
    });

    if (text.isEmpty) {
      esValido = false;
      _codigoError = "El código es obligatorio";
    } else if (text.length < 4) {
      esValido = false;
      _codigoError = "Código inválido, debe tener al menos 4 dígitos";
    }

    return esValido;
  }

  void _verificar() {
    FocusScope.of(context).unfocus();

    if (!_validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Código verificado exitosamente"),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Aquí iría la lógica para navegar a la siguiente pantalla (ej. Reset Password)
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const NuevaContrasena()));
  }

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                'Verificar Código',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  text: 'Ingresa el código de verificación que hemos enviado a ',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.TextSoft,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.correo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.TextMain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              AppTextField(
                controller: _codigoController,
                label: 'Código de Verificación',
                hint: 'Ej: 123456',
                keyboard: TextInputType.number,
                errorText: _codigoError,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Verificar',
                radius: 12,
                onPressed: _verificar,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Código reenviado"),
                        backgroundColor: AppColors.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    '¿No recibiste el código? Reenviar',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
