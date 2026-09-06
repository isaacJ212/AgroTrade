import 'dart:convert';

class ApiSession {
  ApiSession._();

  static final ApiSession instance = ApiSession._();

  String? token;
  String? userName;
  String? userId;
  List<String> roles = [];

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  void setAuth({
    required String token,
    String? userName,
    List<String> roles = const [],
  }) {
    this.token = token;
    this.userName = userName;
    this.roles = roles;
    this.userId = _extractUserId(token);
  }

  String? _extractUserId(String token) {
    if (token.startsWith('demo_token')) {
      return '12'; // ID del usuario demo para que la API no falle
    }
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1];
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2: payload += '=='; break;
        case 3: payload += '='; break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decoded);
      return json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']?.toString();
    } catch (e) {
      return null;
    }
  }

  void clear() {
    token = null;
    userName = null;
    userId = null;
    roles = [];
  }
}

