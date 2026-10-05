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
      throw ApiException(response.statusCode, result.message.isNotEmpty ? result.message : 'No se pudo crear el usuario.');
    }

    return result.data!;
  }

  Future<UserDto> getUserByEmail(String email) async {
    final response = await ApiClient.instance.get(UserRoutes.byEmail(email), authorized: true);
    final result = _decodeResult<UserDto>(
      response.jsonBody,
      (json) => UserDto.fromJson(ensureJsonMap(json)),
    );
    if (!result.isSuccess || result.data == null) {
      throw ApiException(response.statusCode, result.message.isNotEmpty ? result.message : 'No se pudo obtener el usuario.');
    }
    return result.data!;
  }

  Future<void> updatePassword({
    required int userId,
    required UpdatePasswordRequestDto dto,
  }) async {
    final response = await ApiClient.instance.patch(
      UserRoutes.updatePassword(userId),
      body: dto.toJson(),
      authorized: true,
    );

    if (response.jsonBody == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }
      throw ApiException(response.statusCode, 'No se pudo actualizar la contraseña.');
    }

    final result = _decodeResult<dynamic>(
      response.jsonBody,
      (json) => json,
    );
    if (!result.isSuccess) {
      throw ApiException(response.statusCode, result.message.isNotEmpty ? result.message : 'No se pudo actualizar la contraseña.');
    }
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
      throw ApiException(response.statusCode, 'No se pudo actualizar el usuario.');
    }

    final result = _decodeResult<dynamic>(
      response.jsonBody,
      (json) => json,
    );
    if (!result.isSuccess) {
      throw ApiException(response.statusCode, result.message.isNotEmpty ? result.message : 'No se pudo actualizar el usuario.');
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
