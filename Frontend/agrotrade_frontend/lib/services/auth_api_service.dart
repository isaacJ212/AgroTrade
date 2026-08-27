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
    final response = await ApiClient.instance.post(
      AuthRoutes.login,
      body: LoginRequestDto(email: email, password: password).toJson(),
    );

    final result = _decodeResult<LoginResponseDto>(
      response.jsonBody,
      (json) => LoginResponseDto.fromJson(ensureJsonMap(json)),
    );

    print(result.data);
    print("codigo ${result.statusCode}");
    if (!result.isSuccess || result.data == null) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo iniciar sesión.',
      );
    }

    ApiSession.instance.setAuth(
      token: result.data!.token,
      userName: result.data!.userName,
    );
    return result.data!;
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
