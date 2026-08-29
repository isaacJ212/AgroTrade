import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/components.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final TextEditingController _emailController = TextEditingController();

  String? _emailError;

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

  void _enviarInstrucciones() {
    // APRENDIZAJE: esconde el teclado antes de mostrar el SnackBar
    FocusScope.of(context).unfocus();

    if (!_validate()) return;

    // APRENDIZAJE: interpolación → metes el email dentro del texto con ${}
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Instrucciones enviadas a ${_emailController.text.trim()}",
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
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
                              label: "Enviar Instrucciones",
                              radius: 10,
                              onPressed: _enviarInstrucciones,
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
