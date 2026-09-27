import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_session.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();

  String get baseUrl {
    const envBaseUrl = "http://localhost:5080";
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
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    };

    final token = ApiSession.instance.token;
    if (authorized && token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final uri = _buildUri(path, queryParameters);
    final payload = body == null ? null : jsonEncode(body);

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

    return ApiResponse.fromHttpResponse(response);
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
