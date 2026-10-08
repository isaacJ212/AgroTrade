import '../models/api/auth_models.dart';
import '../models/api/backend_result.dart';
import '../models/api/json_helpers.dart';
import '../routes/auth_routes.dart';
import 'api_client.dart';
import 'api_session.dart';
import 'repartidor_api_service.dart';

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
        await ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          userEmail: cleanEmail,
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
        await ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          userEmail: cleanEmail,
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
        await ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          userEmail: cleanEmail,
          roles: demoUser.roles,
        );
        // Para usuarios demo, no llamamos al backend real
        // El estado se puede simular o dejar null
        return demoUser;
      }
    } else if (cleanEmail == 'admin@agrotrade.com') {
      if (cleanPass == 'admin123' || cleanPass == '123456') {
        const demoUser = LoginResponseDto(
          userName: 'Admin AgroTrade',
          token: 'demo_token_admin_agrotrade',
          roles: ['Administrador'],
        );
        await ApiSession.instance.setAuth(
          token: demoUser.token,
          userName: demoUser.userName,
          userEmail: cleanEmail,
          roles: demoUser.roles,
        );
        return demoUser;
      }
    }

    // 2. Si no es un usuario demo, intentar autenticación con el Backend
    try {
      final payload = LoginRequestDto(
        email: email,
        password: password,
      ).toJson();
      final response = await ApiClient.instance.post(
        AuthRoutes.login,
        body: payload,
      );

      final result = _decodeResult<LoginResponseDto>(
        response.jsonBody,
        (json) => LoginResponseDto.fromJson(ensureJsonMap(json)),
      );

      if (response.statusCode == 200 &&
          result.isSuccess &&
          result.data != null) {
        await ApiSession.instance.setAuth(
          token: result.data!.token,
          refreshToken: result.data!.refreshToken,
          userName: result.data!.userName,
          userEmail: cleanEmail,
          roles: result.data!.roles,
        );
        
        // Si el usuario tiene rol Repartidor, verificar estado de verificación
        if (result.data!.roles.contains('Repartidor')) {
          await _cargarEstadoRepartidor();
        }
        
        return result.data!;
      } else {
        throw ApiException(
          response.statusCode,
          result.message.isNotEmpty
              ? result.message
              : 'Credenciales inválidas o error del servidor.',
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw const ApiException(
        500,
        'Error de conexión. Revisa que el backend esté ejecutándose.',
      );
    }
  }

  Future<LoginResponseDto> googleSignIn(String idToken, int? idRol) async {
    final response = await ApiClient.instance.post(
      AuthRoutes.googleSignIn,
      body: GoogleSignInRequestDto(idToken: idToken, idRol: idRol).toJson(),
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

    await ApiSession.instance.setAuth(
      token: result.data!.token,
      refreshToken: result.data!.refreshToken,
      userName: result.data!.userName,
      roles: result.data!.roles,
    );
    
    // Si el usuario tiene rol Repartidor, verificar estado de verificación
    if (result.data!.roles.contains('Repartidor')) {
      await _cargarEstadoRepartidor();
    }
    
    return result.data!;
  }

  Future<void> completeGoogleInfo(GoogleCatchDataDto dto) async {
    final response = await ApiClient.instance.put(
      AuthRoutes.completeInfo,
      body: dto.toJson(),
      authorized: true,
    );

    if (response.jsonBody == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      throw ApiException(
        response.statusCode,
        'No se pudo guardar la información adicional.',
      );
    }

    final result = _decodeResult<dynamic>(response.jsonBody, (json) => json);
    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo guardar la información adicional.',
      );
    }
  }

  Future<LoginResponseDto> verifyCode({
    required int userId,
    required String code,
  }) async {
    final response = await ApiClient.instance.post(
      AuthRoutes.verifyCode,
      body: {'userId': userId, 'code': code},
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
            : 'No se pudo verificar el código.',
      );
    }

    await ApiSession.instance.setAuth(
      token: result.data!.token,
      refreshToken: result.data!.refreshToken,
      userName: result.data!.userName,
      userEmail: ApiSession.instance.userEmail,
      userIdOverride: userId.toString(),
      roles: result.data!.roles,
    );
    
    // Si el usuario tiene rol Repartidor, verificar estado de verificación
    if (result.data!.roles.contains('Repartidor')) {
      await _cargarEstadoRepartidor();
    }
    
    return result.data!;
  }

  Future<bool> restoreSession() async {
    await ApiSession.instance.restoreStoredSession();
    if (ApiSession.instance.refreshToken == null) return false;
    return ApiClient.instance.refreshSession();
  }

  Future<void> logout() async {
    final session = ApiSession.instance;
    final refreshToken = session.refreshToken;
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await ApiClient.instance.post(
          AuthRoutes.logout,
          body: {'refreshToken': refreshToken},
        );
      }
    } catch (_) {
      // Limpiar sesión local aunque no haya conexión con el backend.
    } finally {
      await session.clear();
    }
  }

  BackendResult<T> _decodeResult<T>(
    Map<String, dynamic>? json,
    T Function(Object? json) parser,
  ) {
    final safeJson = json ?? const <String, dynamic>{};
    return BackendResult<T>.fromJson(safeJson, dataParser: parser);
  }

  /// Carga el estado de verificación del repartidor y lo guarda en la sesión
  Future<void> _cargarEstadoRepartidor() async {
    try {
      final estado = await RepartidorApiService.instance.getEstadoVerificacion();
      await ApiSession.instance.setRepartidorEstado(estado);
    } catch (e) {
      // Si falla, no bloqueamos el login; el estado se verificará al entrar a homeRepartidor
      // print('Error cargando estado repartidor: $e');
    }
  }
}
