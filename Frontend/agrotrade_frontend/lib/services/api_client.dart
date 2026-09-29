import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/api/auth_models.dart';
import '../models/api/backend_result.dart';
import '../models/api/json_helpers.dart';
import '../routes/auth_routes.dart';
import 'api_session.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();
  Future<bool>? _refreshOperation;

  String get baseUrl {
    const envBaseUrl = "http://10.0.2.2:5080";
    return envBaseUrl.endsWith('/')
        ? envBaseUrl.substring(0, envBaseUrl.length - 1)
        : envBaseUrl;
  }

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$baseUrl$normalizedPath');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: queryParameters);
  }

  Future<ApiResponse> get(
    String path, {
    bool authorized = false,
    Map<String, String>? queryParameters,
  }) {
    return _send(
      'GET',
      path,
      authorized: authorized,
      queryParameters: queryParameters,
    );
  }

  Future<ApiResponse> post(
    String path, {
    Object? body,
    bool authorized = false,
  }) {
    return _send('POST', path, body: body, authorized: authorized);
  }

  Future<ApiResponse> put(
    String path, {
    Object? body,
    bool authorized = false,
  }) {
    return _send('PUT', path, body: body, authorized: authorized);
  }

  Future<ApiResponse> patch(
    String path, {
    Object? body,
    bool authorized = false,
  }) {
    return _send('PATCH', path, body: body, authorized: authorized);
  }

  Future<ApiResponse> delete(
    String path, {
    Object? body,
    bool authorized = false,
  }) {
    return _send('DELETE', path, body: body, authorized: authorized);
  }

  Future<ApiResponse> _send(
    String method,
    String path, {
    Object? body,
    bool authorized = false,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final payload = body == null ? null : jsonEncode(body);
    var response = await _sendRequest(
      method,
      uri,
      payload,
      authorized: authorized,
    );

    final isRefreshOrLogout =
        path.toLowerCase().endsWith('/refresh') ||
        path.toLowerCase().endsWith('/logout');
    if (authorized &&
        response.statusCode == 401 &&
        !isRefreshOrLogout &&
        await refreshSession()) {
      response = await _sendRequest(method, uri, payload, authorized: true);
    }

    return ApiResponse.fromHttpResponse(response);
  }

  Future<http.Response> _sendRequest(
    String method,
    Uri uri,
    String? payload, {
    required bool authorized,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    };

    final token = ApiSession.instance.token;
    if (authorized && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    late final http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(uri, headers: headers, body: payload);
        break;
      case 'PUT':
        response = await _client.put(uri, headers: headers, body: payload);
        break;
      case 'PATCH':
        response = await _client.patch(uri, headers: headers, body: payload);
        break;
      case 'DELETE':
        response = await _client.delete(uri, headers: headers, body: payload);
        break;
      default:
        throw ApiException(0, 'Método HTTP no soportado: $method');
    }

    return response;
  }

  Future<bool> refreshSession() async {
    final pending = _refreshOperation;
    if (pending != null) return pending;

    final operation = _performRefresh();
    _refreshOperation = operation;
    try {
      return await operation;
    } finally {
      if (identical(_refreshOperation, operation)) {
        _refreshOperation = null;
      }
    }
  }

  Future<bool> _performRefresh() async {
    try {
      final session = ApiSession.instance;
      await session.restoreStoredSession();
      final currentRefreshToken = session.refreshToken;
      if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
        return false;
      }

      final response = await _client
          .post(
            _buildUri(AuthRoutes.refresh),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: jsonEncode({'refreshToken': currentRefreshToken}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 401) {
        await session.clear();
        return false;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final apiResponse = ApiResponse.fromHttpResponse(response);
      final result = BackendResult<TokensResponseDto>.fromJson(
        apiResponse.jsonBody ?? const <String, dynamic>{},
        dataParser: (json) => TokensResponseDto.fromJson(ensureJsonMap(json)),
      );
      final tokens = result.data;
      if (!result.isSuccess ||
          tokens == null ||
          tokens.accessToken.isEmpty ||
          tokens.refreshToken.isEmpty) {
        return false;
      }

      await session.updateTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return true;
    } catch (_) {
      // Mantener el refresh token ante fallos temporales de red.
      return false;
    }
  }
}

class ApiResponse {
  final int statusCode;
  final String rawBody;
  final Map<String, dynamic>? jsonBody;

  const ApiResponse({
    required this.statusCode,
    required this.rawBody,
    required this.jsonBody,
  });

  factory ApiResponse.fromHttpResponse(http.Response response) {
    if (response.body.isEmpty) {
      return ApiResponse(
        statusCode: response.statusCode,
        rawBody: '',
        jsonBody: null,
      );
    }

    final body = response.body;
    try {
      final decoded = jsonDecode(body);
      return ApiResponse(
        statusCode: response.statusCode,
        rawBody: body,
        jsonBody: decoded is Map<String, dynamic>
            ? decoded
            : {'value': decoded},
      );
    } catch (_) {
      return ApiResponse(
        statusCode: response.statusCode,
        rawBody: body,
        jsonBody: null,
      );
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
