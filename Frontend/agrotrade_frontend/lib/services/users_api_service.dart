import '../models/api/backend_result.dart';
import '../models/api/json_helpers.dart';
import '../models/api/user_models.dart';
import '../routes/user_routes.dart';
import 'api_client.dart';

class UsersApiService {
  UsersApiService._();

  static final UsersApiService instance = UsersApiService._();

  Future<UserDto> createUser(CreateUserRequestDto dto) async {
    final payload = dto.toJson();
    print("DEBUG: [UsersApiService] Payload enviado a registro: $payload");
    final response = await ApiClient.instance.post(
      UserRoutes.base,
      body: payload,
    );

    final result = _decodeResult<UserDto>(
      response.jsonBody,
      (json) => UserDto.fromJson(ensureJsonMap(json)),
    );

    if (!result.isSuccess || result.data == null) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo crear el usuario.',
      );
    }

    return result.data!;
  }

  Future<UserDto> getUserByEmail(String email) async {
    final response = await ApiClient.instance.get(
      UserRoutes.byEmail(email),
      authorized: true,
    );
    final result = _decodeResult<UserDto>(
      response.jsonBody,
      (json) => UserDto.fromJson(ensureJsonMap(json)),
    );
    if (!result.isSuccess || result.data == null) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo obtener el usuario.',
      );
    }
    return result.data!;
  }

  Future<void> sendPasswordCode({required int userId}) async {
    final response = await ApiClient.instance.post(
      UserRoutes.sendPasswordCode(userId),
      authorized: true,
    );
    _ensureNoContentSuccess(response, 'No se pudo enviar el código.');
  }

  Future<void> verifyPasswordCode({
    required int userId,
    required String code,
  }) async {
    final response = await ApiClient.instance.post(
      UserRoutes.verifyPasswordCode(userId),
      body: {'code': code},
      authorized: true,
    );
    _ensureNoContentSuccess(response, 'El código es incorrecto o ha expirado.');
  }

  Future<void> resetPasswordAfterOtp({
    required int userId,
    required String newPassword,
  }) async {
    final response = await ApiClient.instance.post(
      UserRoutes.resetPassword(userId),
      body: {'newPassword': newPassword},
      authorized: true,
    );
    _ensureNoContentSuccess(response, 'No se pudo restablecer la contraseña.');
  }

  Future<void> sendPasswordRecoveryCode({required String email}) async {
    final response = await ApiClient.instance.post(
      UserRoutes.sendPasswordRecoveryCode,
      body: {'email': email.trim()},
    );
    _ensureNoContentSuccess(
      response,
      'No se pudo procesar la solicitud de recuperación.',
    );
  }

  Future<void> verifyPasswordRecoveryCode({
    required String email,
    required String code,
  }) async {
    final response = await ApiClient.instance.post(
      UserRoutes.verifyPasswordRecoveryCode,
      body: {'email': email.trim(), 'code': code},
    );
    _ensureNoContentSuccess(response, 'El código es incorrecto o expiró.');
  }

  Future<void> resetPasswordByRecoveryCode({
    required String email,
    required String newPassword,
  }) async {
    final response = await ApiClient.instance.post(
      UserRoutes.resetPasswordRecovery,
      body: {'email': email.trim(), 'newPassword': newPassword},
    );
    _ensureNoContentSuccess(response, 'No se pudo restablecer la contraseña.');
  }

  void _ensureNoContentSuccess(ApiResponse response, String fallback) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    final message =
        response.jsonBody?['message'] ??
        response.jsonBody?['Message'] ??
        response.jsonBody?['errorMessage'] ??
        response.jsonBody?['ErrorMessage'] ??
        response.jsonBody?['error'] ??
        response.jsonBody?['Error'];
    throw ApiException(
      response.statusCode,
      message is String && message.isNotEmpty ? message : fallback,
    );
  }

  Future<void> updateUser({
    required int userId,
    required UpdateUserRequestDto dto,
  }) async {
    final response = await ApiClient.instance.put(
      UserRoutes.byId(userId),
      body: dto.toJson(),
      authorized: true,
    );

    if (response.jsonBody == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }
      throw ApiException(
        response.statusCode,
        'No se pudo actualizar el usuario.',
      );
    }

    final result = _decodeResult<dynamic>(response.jsonBody, (json) => json);
    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo actualizar el usuario.',
      );
    }
  }

  BackendResult<T> _decodeResult<T>(
    Map<String, dynamic>? json,
    T Function(Object? json) parser,
  ) {
    return BackendResult<T>.fromJson(
      json ?? const <String, dynamic>{},
      dataParser: parser,
    );
  }
}
