import '../models/api/auth_models.dart';
import '../models/api/backend_result.dart';
import '../models/api/json_helpers.dart';
import '../routes/auth_routes.dart';
import 'api_client.dart';
import 'api_session.dart';

class AuthApiService {
  AuthApiService._();

  static final AuthApiService instance = AuthApiService._();

  Future<LoginResponseDto> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPass = password.trim();

    // 1. Acceso instantáneo para usuarios predefinidos de prueba (0 ms)
    if (cleanEmail == 'cliente@agrotrade.com' ||
        cleanEmail == 'maria@agrotrade.com') {
      if (cleanPass == 'cliente123' || cleanPass == '123456') {
        const demoUser = LoginResponseDto(
          userName: 'María López',
          token: 'demo_token_cliente_agrotrade',
          roles: ['Cliente'],
        );
        ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          roles: demoUser.roles,
        );
        return demoUser;
      }
    } else if (cleanEmail == 'productor@agrotrade.com' ||
        cleanEmail == 'carlos@agrotrade.com') {
      if (cleanPass == 'productor123' || cleanPass == '123456') {
        const demoUser = LoginResponseDto(
          userName: 'Carlos Martínez',
          token: 'demo_token_productor_agrotrade',
          roles: ['Productor/Proveedor'],
        );
        ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          roles: demoUser.roles,
        );
        return demoUser;
      }
    } else if (cleanEmail == 'repartidor@agrotrade.com' ||
        cleanEmail == 'juan@agrotrade.com') {
      if (cleanPass == 'repartidor123' || cleanPass == '123456') {
        const demoUser = LoginResponseDto(
          userName: 'Juan Pérez',
          token: 'demo_token_repartidor_agrotrade',
          roles: ['Repartidor'],
        );
        ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          roles: demoUser.roles,
        );
        return demoUser;
      }
    } else if (cleanEmail == 'admin@agrotrade.com') {
      if (cleanPass == 'admin123' || cleanPass == '123456') {
        const demoUser = LoginResponseDto(
          userName: 'Admin AgroTrade',
          token: 'demo_token_admin_agrotrade',
          roles: ['Administrador'],
        );
        ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          roles: demoUser.roles,
        );
        return demoUser;
      }
    }

    // 2. Si no es un usuario demo, intentar autenticación con el Backend
    try {
      print('--- INICIANDO LOGIN CON BACKEND ---');
      final payload = LoginRequestDto(
        email: email,
        password: password,
      ).toJson();
      print('Payload: $payload');

      final response = await ApiClient.instance.post(
        AuthRoutes.login,
        body: payload,
      );

      print('Status Code: ${response.statusCode}');
      print('Raw Body: ${response.rawBody}');

      final result = _decodeResult<LoginResponseDto>(
        response.jsonBody,
        (json) => LoginResponseDto.fromJson(ensureJsonMap(json)),
      );

      print('IsSuccess: ${result.isSuccess}, Data: ${result.data != null}');

      if (response.statusCode == 200 &&
          result.isSuccess &&
          result.data != null) {
        ApiSession.instance.setAuth(
          token: result.data!.token,
          userName: result.data!.userName,
          roles: result.data!.roles,
        );
        print('Login exitoso.');
        return result.data!;
      } else {
        print('Error en la respuesta del backend: ${result.message}');
        throw ApiException(
          response.statusCode,
          result.message.isNotEmpty
              ? result.message
              : 'Credenciales inválidas o error del servidor.',
        );
      }
    } catch (e) {
      print('Excepción capturada en login: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw const ApiException(
        500,
        'Error de conexión. Revisa que el backend esté ejecutándose.',
      );
    }
  }

  Future<LoginResponseDto> googleSignIn(String idToken) async {
    final response = await ApiClient.instance.post(
      AuthRoutes.googleSignIn,
      body: GoogleSignInRequestDto(idToken: idToken).toJson(),
    );

    final result = _decodeResult<LoginResponseDto>(
      response.jsonBody,
      (json) => LoginResponseDto.fromJson(ensureJsonMap(json)),
    );

    if (!result.isSuccess || result.data == null) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo autenticar con Google.',
      );
    }

    ApiSession.instance.setAuth(
      token: result.data!.token,
      userName: result.data!.userName,
      roles: result.data!.roles,
    );
    return result.data!;
  }

  Future<void> verifyCode({required int userId, required String code}) async {
    final response = await ApiClient.instance.post(
      AuthRoutes.verifyCode,
      body: {'userId': userId, 'code': code},
    );

    final result = _decodeResult<dynamic>(response.jsonBody, (json) => json);
    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo verificar el código.',
      );
    }
  }

  BackendResult<T> _decodeResult<T>(
    Map<String, dynamic>? json,
    T Function(Object? json) parser,
  ) {
    final safeJson = json ?? const <String, dynamic>{};
    return BackendResult<T>.fromJson(safeJson, dataParser: parser);
  }
}
