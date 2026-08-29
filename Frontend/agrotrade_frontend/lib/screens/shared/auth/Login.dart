import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/models/api/auth_models.dart';
import 'package:agrotrade_frontend/screens/cliente/inicioComprador.dart';
import 'package:agrotrade_frontend/screens/productor/inicioProductor.dart';
import 'package:agrotrade_frontend/screens/repartidor/homeRepartidor.dart';
import 'package:agrotrade_frontend/screens/shared/auth/registro.dart';
import 'package:agrotrade_frontend/screens/shared/auth/resetPassword.dart';
import 'package:agrotrade_frontend/screens/shared/auth/roleSelection.dart';
import 'package:agrotrade_frontend/services/api_client.dart';
import 'package:agrotrade_frontend/services/auth_api_service.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    }
  }

  void _autofillDemo(String email, String pass) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = pass;
      _emailError = null;
      _passwordError = null;
    });
  }

  void _redirectNavigation(LoginResponseDto user) {
    if (user.roles.contains("Cliente")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioComprador()),
      );
    } else if (user.roles.contains("Productor/Proveedor")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioProductor()),
      );
    } else if (user.roles.contains("Repartidor")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioRepartidor()),
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
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Image.asset(
                      "lib/assets/images/Brand.png",
                      height: 72,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    "Bienvenido de nuevo",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.Title,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Accede a tu cuenta para gestionar tus compras y cultivos",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.SubTitle,
                  ),
                  const SizedBox(height: 24),

                  // Botones rápidos para rellenar credenciales predefinidas (Demo)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _DemoChip(
                        label: "Comprador",
                        onTap: () => _autofillDemo("cliente@agrotrade.com", "cliente123"),
                      ),
                      _DemoChip(
                        label: "Productor",
                        onTap: () => _autofillDemo("productor@agrotrade.com", "productor123"),
                      ),
                      _DemoChip(
                        label: "Repartidor",
                        onTap: () => _autofillDemo("repartidor@agrotrade.com", "repartidor123"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  AppTextField(
                    hint: "ejemplo@email.com",
                    label: "Correo electrónico",
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

                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _remember,
                              onChanged: (v) => setState(() => _remember = v ?? false),
                            ),
                            const Text(
                              "Recordarme",
                              style: AppTextStyles.SubTitle,
                            ),
                          ],
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
                          "¿Olvidaste tu clave?",
                          style: AppTextStyles.SubTitle.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    label: _isLoading ? "Ingresando..." : "Iniciar Sesión",
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "¿No tienes cuenta?  ",
                        style: AppTextStyles.SubTitle,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Registro()),
                        ),
                        child: Text(
                          "Regístrate",
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

class _DemoChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DemoChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.titleDark,
          ),
        ),
      ),
    );
  }
}
