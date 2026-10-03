import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../../../models/api/user_models.dart';
import '../../../services/users_api_service.dart';
import '../../../services/auth_api_service.dart';
import '../../../services/api_session.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../../../routes/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'verificarCodigo.dart';

class Registro extends StatefulWidget {
  final int? idRol;
  const Registro({super.key, this.idRol});

  @override
  State<StatefulWidget> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerApellidoController = TextEditingController();
  final TextEditingController _segundoApellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _departamentController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _direccionExactaController = TextEditingController();

  String? _nombreError;
  String? _primerApellidoError;
  String? _segundoApellidoError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _numberError;
  String? _departamentoError;
  String? _municipioError;
  String? _direccionExactaError;

  bool _terminosAcepta = false;
  bool _isLoading = false;
  int? _idRol;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '68671877007-u61dd67hhnr2ou6lmut467r1tmftcu42.apps.googleusercontent.com',
  );

  @override
  void initState() {
    super.initState();
    _idRol = widget.idRol;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_idRol == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        _idRol = args;
        print(
          "DEBUG: [Registro] idRol recuperado en didChangeDependencies: $_idRol",
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _primerApellidoController.dispose();
    _segundoApellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _numberController.dispose();
    _departamentController.dispose();
    _municipioController.dispose();
    _direccionExactaController.dispose();
    super.dispose();
  }

  bool _validar() {
    String? nombreError;
    String? primerApellidoError;
    String? segundoApellidoError;
    String? emailError;
    String? passwordError;
    String? confirmError;
    String? numberError;
    String? departamentoError;
    String? municipioError;
    String? direccionExactaError;

    //Lectura

    final nombre = _nombreController.text.trim();
    final primerApellido = _primerApellidoController.text.trim();
    final segundoApellido = _segundoApellidoController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();
    final departamento = _departamentController.text.trim();
    final municipio = _municipioController.text.trim();
    final direccionExacta = _direccionExactaController.text.trim();
    final telefono = _numberController.text.trim();

    if (nombre.isEmpty) {
      nombreError = "El nombre es obligatorio";
    } else if (nombre.length < 2) {
      nombreError = "Mínimo 2 caracteres";
    }

    if (primerApellido.isEmpty) {
      primerApellidoError = "El primer apellido es obligatorio";
    } else if (primerApellido.length < 2) {
      primerApellidoError = "Mínimo 2 caracteres";
    }

    if (segundoApellido.isEmpty) {
      segundoApellidoError = "El segundo apellido es obligatorio";
    } else if (segundoApellido.length < 2) {
      segundoApellidoError = "Mínimo 2 caracteres";
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
    if (departamento.isEmpty) {
      departamentoError = "El departamento es obligatorio";
    }
    if (municipio.isEmpty) {
      municipioError = "El municipio es obligatorio";
    }
    if (direccionExacta.isEmpty) {
      direccionExactaError = "La dirección exacta es obligatoria";
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
      _primerApellidoError = primerApellidoError;
      _segundoApellidoError = segundoApellidoError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmError = confirmError;
      _numberError = numberError;
      _departamentoError = departamentoError;
      _municipioError = municipioError;
      _direccionExactaError = direccionExactaError;
    });

    // Válido si TODOS los errores son null Y aceptó los términos
    return nombreError == null &&
        primerApellidoError == null &&
        segundoApellidoError == null &&
        emailError == null &&
        passwordError == null &&
        numberError == null &&
        departamentoError == null &&
        municipioError == null &&
        direccionExactaError == null &&
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
      print(
        "DEBUG: [Registro] Iniciando creación de cuenta con idRol: $_idRol",
      );
      final usuarioCreado = await UsersApiService.instance.createUser(
        CreateUserRequestDto(
          nombre: _nombreController.text.trim(),
          primerApellido: _primerApellidoController.text.trim(),
          segundoApellido: _segundoApellidoController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          telefono: _numberController.text.trim(),
          departamento: _departamentController.text.trim(),
          municipio: _municipioController.text.trim(),
          direccionExacta: _direccionExactaController.text.trim(),
          idRol: _idRol,
        ),
      );
      print("DEBUG: [Registro] Cuenta creada correctamente en la API");
      if (usuarioCreado.id <= 0) {
        throw const ApiException(
          0,
          'La cuenta se creó, pero la API no devolvió un ID válido para verificar el código.',
        );
      }

      final correoApi = usuarioCreado.email.trim();
      final correo = correoApi.isNotEmpty
          ? correoApi
          : _emailController.text.trim();
      ApiSession.instance.setPendingVerification(
        userId: usuarioCreado.id,
        email: correo,
      );

      if (!mounted) return;
      _mostrarSnackBar(
        'Cuenta creada. Revisa tu correo: el OTP fue enviado automáticamente.',
        error: false,
      );

      final verified = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => VerificarCodigo(
            correo: correo,
            userId: usuarioCreado.id,
            title: 'Verifica tu correo',
          ),
        ),
      );
      if (!mounted || verified != true) return;

      final roles = ApiSession.instance.roles;
      if (roles.contains('Cliente') || roles.contains('Comprador')) {
        print("DEBUG: [Registro] Redirigiendo a Inicio Comprador");
        Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
      } else if (roles.contains('Productor') ||
          roles.contains('Proveedor') ||
          roles.contains('Productor/Proveedor')) {
        print("DEBUG: [Registro] Redirigiendo a Inicio Productor");
        Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
      } else if (roles.contains('Repartidor')) {
        print("DEBUG: [Registro] Redirigiendo a Inicio Repartidor");
        Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
      } else {
        print(
          "DEBUG: [Registro] Rol no detectado, redirigiendo a Login manual",
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } on ApiException catch (e) {
      print("DEBUG: [Registro] ApiException capturada: ${e.message}");
      if (!mounted) return;
      _mostrarSnackBar(e.message);
    } catch (e) {
      print("DEBUG: [Registro] Error inesperado capturado: $e");
      if (!mounted) return;
      _mostrarSnackBar("Error inesperado: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _continuarConGoogle() async {
    setState(() => _isLoading = true);

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const ApiException(0, 'No se pudo obtener el token de Google.');
      }

      final user = await AuthApiService.instance.googleSignIn(idToken, _idRol);
      if (!mounted) return;

      if (user.requiereCompletarInformacion) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.completarInformacionGoogle,
        );
      } else if (user.roles.contains('Cliente') ||
          user.roles.contains('Comprador')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
      } else if (user.roles.contains('Productor') ||
          user.roles.contains('Proveedor') ||
          user.roles.contains('Productor/Proveedor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
      } else if (user.roles.contains('Repartidor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnackBar(e.message);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnackBar('No se pudo iniciar sesión con Google.');
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
                  hint: "Ej: Juan",
                  label: "Nombre",
                  controller: _nombreController,
                  errorText: _nombreError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "Ej: Perez",
                  label: "Primer Apellido",
                  controller: _primerApellidoController,
                  errorText: _primerApellidoError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "Ej: Lopez",
                  label: "Segundo Apellido",
                  controller: _segundoApellidoController,
                  errorText: _segundoApellidoError,
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
                  errorText: _numberError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "Managua",
                  label: 'Departamento',
                  errorText: _departamentoError,
                  controller: _departamentController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "Managua",
                  label: 'Municipio',
                  errorText: _municipioError,
                  controller: _municipioController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hint: "Del parque 1c al lago",
                  label: 'Dirección Exacta',
                  errorText: _direccionExactaError,
                  controller: _direccionExactaController,
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
                const OrDivider(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _continuarConGoogle,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF747775),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://developers.google.com/identity/images/g-logo.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuar con Google',
                          style: TextStyle(
                            color: Color(0xFF1F1F1F),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      onTap: () {
                        print("DEBUG: [Registro] Navegando a Login");
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
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
