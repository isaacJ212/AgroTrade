import 'package:flutter/foundation.dart';
import '../../../models/api/user_models.dart';
import '../../../services/api_client.dart';
import '../../../services/users_api_service.dart';
import 'Login.dart';
import '../onboarding/onBoarding.dart';
import 'package:flutter/material.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<StatefulWidget> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _departamentController = TextEditingController();

  String? _nombreError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _numberError;
  String? _cityError;

  bool _terminosAcepta = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _numberController.dispose();
    _departamentController.dispose();
    super.dispose();
  }

  bool _validar() {
    String? nombreError;
    String? emailError;
    String? passwordError;
    String? confirmError;
    String? numberError;
    String? cityError;

    //Lectura

    final nombre = _nombreController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();
    final city = _departamentController.text.trim();
    final telefono = _numberController.text.trim();

    // --- NOMBRE: backend exige al menos 15 caracteres ---
    if (nombre.isEmpty) {
      nombreError = "El nombre es obligatorio";
    } else if (nombre.length < 15) {
      nombreError = "Mínimo 15 caracteres";
    }

    // --- EMAIL: formato básico ---
    if (email.isEmpty) {
      emailError = "El correo es obligatorio";
    } else if (!email.contains("@") || !email.contains(".")) {
      emailError = "Correo inválido";
    }

    // --- CONTRASEÑA: mínimo 6 caracteres ---
    if (password.isEmpty) {
      passwordError = "La contraseña es obligatoria";
    } else if (password.length < 6) {
      passwordError = "Mínimo 6 caracteres";
    }

    // --- CONFIRMAR CONTRASEÑA: debe coincidir ---
    // APRENDIZAJE: aquí comparamos DOS controllers entre sí
    if (confirm.isEmpty) {
      confirmError = "Confirma tu contraseña";
    } else if (password != confirm) {
      confirmError = "Las contraseñas no coinciden";
    }
    if (city.isEmpty) {
      confirmError = " El departamento es obligatorio";
    }

    // --- TELÉFONO: backend valida 8 dígitos y debe comenzar con 5, 7 u 8 ---
    final regexTelefono = RegExp(r'^[578]\d{7}$');
    if (telefono.isEmpty) {
      numberError = "El teléfono es obligatorio";
    } else if (!regexTelefono.hasMatch(telefono)) {
      numberError = "Teléfono inválido (8 dígitos, inicia con 5, 7 u 8)";
    }

    // Un solo setState al final → redibuja todos los errores de una vez
    setState(() {
      _nombreError = nombreError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmError = confirmError;
      _numberError = numberError;
      _cityError = cityError;
    });

    // Válido si TODOS los errores son null Y aceptó los términos
    return nombreError == null &&
        emailError == null &&
        passwordError == null &&
        numberError == null &&
        numberError == null &&
        cityError == null &&
        _terminosAcepta;
  }

  void _mostrarSnackBar(String mensaje, {bool error = true}) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? AppColors.errorColor : AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _crearCuenta() async {
    if (!_validar()) {
      if (!_terminosAcepta) {
        _mostrarSnackBar("Debes aceptar los términos y condiciones");
      } else {
        _mostrarSnackBar("Revisa los campos marcados en rojo");
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await UsersApiService.instance.createUser(
        CreateUserRequestDto(
          nombreCompleto: _nombreController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          telefono: _numberController.text.trim(),
          departamento: _departamentController.text.trim(),
        ),
      );

      if (!mounted) return;
      _mostrarSnackBar("¡Cuenta creada con éxito!", error: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoarding()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnackBar(e.message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    "lib/assets/images/Brand.png",
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Crear Cuenta",
                  style: AppTextStyles.Title,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Unete a la red Agricola mas confiable",
                  style: AppTextStyles.SubTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                AppTextField(
                  hint: "Ej: Juan Perez Lopez",
                  label: "Nombre Completo",
                  controller: _nombreController,
                  errorText: _nombreError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "juan@gmail.com",
                  label: "Correo Electronico",
                  controller: _emailController,
                  errorText: _emailError,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  hint: "********",
                  label: "Contraseña",
                  controller: _passwordController,
                  errorText: _passwordError,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  hint: "********",
                  label: "Confirmar Contraseña",
                  controller: _confirmController,
                  errorText: _confirmError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "+505 8888 8888",
                  label: "Numero de telefono",
                  keyboard: TextInputType.phone,
                  controller: _numberController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "Managua",
                  label: 'Departamento',
                  errorText: _cityError,
                  controller: _departamentController,
                ),
                const SizedBox(height: 16),

                // Checkbox con texto enriquecido (términos en verde)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _terminosAcepta,
                      onChanged: (v) =>
                          setState(() => _terminosAcepta = v ?? false),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "Acepto los ",
                          style: AppTextStyles.SubTitle,
                          children: [
                            TextSpan(
                              text: "términos y condiciones",
                              style: AppTextStyles.SubTitle.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: " de AgroTrade."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: _isLoading ? "Creando..." : "Crear Cuenta",
                  radius: 15,
                  onPressed: _isLoading ? null : _crearCuenta,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿Ya tienes cuenta? ",
                      style: AppTextStyles.SubTitle,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        " Inicia Sesion",
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
    );
  }
}
