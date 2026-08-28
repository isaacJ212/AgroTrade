import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../../../services/auth_api_service.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import 'registro.dart';
import 'resetPassword.dart';
import 'roleSelection.dart';

import 'package:agrotrade_frontend/models/api/auth_models.dart';
import 'package:agrotrade_frontend/screens/repartidor/homeRepartidor.dart';
import 'package:agrotrade_frontend/screens/productor/inicioProductor.dart';
import 'package:agrotrade_frontend/screens/shared/auth/registro.dart';
import 'package:agrotrade_frontend/screens/shared/auth/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import 'roleSelection.dart';
import '/../services/auth_api_service.dart';
import '/services/api_client.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // los controllers son como los inputs.value
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _remember = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validar() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool esValido = true;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _emailError = "El correo es obligatorio";
      esValido = false;
    } else if (!email.contains("@") || !email.contains(".")) {
      _emailError = "Correo inválido";
      esValido = false;
    }

    if (password.isEmpty) {
      _passwordError = "La contraseña es obligatoria";
      esValido = false;
    } else if (password.length < 6) {
      _passwordError = "Mínimo 6 caracteres";
      esValido = false;
    }

    return esValido;
  }

  Future<void> _iniciarSesion() async {
    if (_validar()) {
      setState(() => _isLoading = true);
      try {
        final user = await AuthApiService.instance.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;
        _redirectNavigation(user);
      } on ApiException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
      return;
    }
  }

  // Creo que se explica solo pero por si acaso es solo para redireccionar segun el rol
  void _redirectNavigation(LoginResponseDto user) {
    if (user.roles.contains("Administrador")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Roleselection()),
      );
    } else if (user.roles.contains("Repartidor")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioRepartidor()),
      );
    } else if (user.roles.contains("Productor/Proveedor")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioProductor()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Roleselection()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Center(child: Image.asset("lib/assets/images/Brand.png")),

                  Text(
                    "Bienvenido de nuevo",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.Title,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Accede a tu cuenta para gestionar tus cultivos",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.SubTitle,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    hint: "ejemplo@email.com",
                    label: "Correo electronico",
                    keyboard: TextInputType.emailAddress,
                    controller: _emailController,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    hint: "********",
                    label: "Contraseña",
                    controller: _passwordController,
                    errorText: _passwordError,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _remember,
                              onChanged: (v) =>
                                  setState(() => _remember = v ?? false),
                            ),
                            const Flexible(
                              child: Text(
                                "Recordar mi sesión",
                                style: AppTextStyles.SubTitle,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RecoverPassword(),
                                ),
                              ),
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: AppTextStyles.SubTitle.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: _isLoading ? "Ingresando..." : "Iniciar Sesion",
                    radius: 10,
                    onPressed: _isLoading ? null : _iniciarSesion,
                  ),
                  const SizedBox(height: 16),
                  const OrDivider(),
                  const SizedBox(height: 16),
                  const SecondaryButton(
                    label: "Continuar Con Google",
                    icon: Icons.g_mobiledata,
                    onPressed: null,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "¿No Tienes Cuenta?  ",
                        style: AppTextStyles.SubTitle,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Registro()),
                        ),
                        child: Text(
                          " Registrate",
                          style: AppTextStyles.SubTitle.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
