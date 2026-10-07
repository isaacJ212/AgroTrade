import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiSession {
  ApiSession._();

  static final ApiSession instance = ApiSession._();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _refreshTokenKey = 'agrotrade.refresh_token';
  static const String _userNameKey = 'agrotrade.user_name';
  static const String _userEmailKey = 'agrotrade.user_email';
  static const String _userPhoneKey = 'agrotrade.user_phone';
  static const String _userLocationKey = 'agrotrade.user_location';

  String? token;
  String? refreshToken;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userLocation;
  String? userId;
  List<String> roles = [];

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  Future<void> setAuth({
    required String token,
    String? refreshToken,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? userLocation,
    String? userIdOverride,
    List<String> roles = const [],
  }) async {
    this.token = token;
    this.userName = (userName != null && userName.isNotEmpty)
        ? userName
        : _extractUserName(token);
    this.userEmail = (userEmail != null && userEmail.isNotEmpty)
        ? userEmail
        : _extractEmail(token);
    if (userPhone != null && userPhone.isNotEmpty) this.userPhone = userPhone;
    if (userLocation != null && userLocation.isNotEmpty) this.userLocation = userLocation;
    this.roles = roles.isNotEmpty ? roles : _extractRoles(token);
    userId = userIdOverride ?? _extractUserId(token);
    this.refreshToken = refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await _secureStorage.delete(key: _refreshTokenKey);
    } else {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
    await _storeOptional(_userNameKey, this.userName);
    await _storeOptional(_userEmailKey, this.userEmail);
    await _storeOptional(_userPhoneKey, this.userPhone);
    await _storeOptional(_userLocationKey, this.userLocation);
  }

  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    token = accessToken;
    this.refreshToken = refreshToken;
    roles = _extractRoles(accessToken);
    userId = _extractUserId(accessToken);
    userName ??= _extractUserName(accessToken);
    userEmail ??= _extractEmail(accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    if (userName != null) await _storeOptional(_userNameKey, userName);
    if (userEmail != null) await _storeOptional(_userEmailKey, userEmail);
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
  }) async {
    if (name != null && name.isNotEmpty) {
      userName = name;
      await _storeOptional(_userNameKey, name);
    }
    if (email != null && email.isNotEmpty) {
      userEmail = email;
      await _storeOptional(_userEmailKey, email);
    }
    if (phone != null && phone.isNotEmpty) {
      userPhone = phone;
      await _storeOptional(_userPhoneKey, phone);
    }
    if (location != null && location.isNotEmpty) {
      userLocation = location;
      await _storeOptional(_userLocationKey, location);
    }
  }

  Future<void> restoreStoredSession() async {
    refreshToken ??= await _secureStorage.read(key: _refreshTokenKey);
    userName ??= await _secureStorage.read(key: _userNameKey);
    userEmail ??= await _secureStorage.read(key: _userEmailKey);
    userPhone ??= await _secureStorage.read(key: _userPhoneKey);
    userLocation ??= await _secureStorage.read(key: _userLocationKey);
  }

  Future<void> _storeOptional(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await _secureStorage.delete(key: key);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  void setPendingVerification({required int userId, required String email}) {
    token = null;
    userName = null;
    roles = [];
    this.userId = userId.toString();
    userEmail = email;
  }

  List<String> _extractRoles(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return const [];
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      final claims = jsonDecode(utf8.decode(base64Url.decode(payload)));
      final rawRoles =
          claims['role'] ??
          claims['roles'] ??
          claims['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      if (rawRoles is List)
        return rawRoles.map((role) => role.toString()).toList();
      if (rawRoles is String && rawRoles.isNotEmpty) return [rawRoles];
      return const [];
    } catch (_) {
      return const [];
    }
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
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decoded);
      return json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
          ?.toString();
    } catch (e) {
      return null;
    }
  }

  String? _extractEmail(String token) {
    if (token.startsWith('demo_token')) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2: payload += '=='; break;
        case 3: payload += '='; break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decoded);
      return json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']
          ?? json['email']
          ?? json['mail'];
    } catch (_) {
      return null;
    }
  }

  String? _extractUserName(String token) {
    if (token.startsWith('demo_token')) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2: payload += '=='; break;
        case 3: payload += '='; break;
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decoded);
      return json['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
          ?? json['name']
          ?? json['unique_name'];
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    token = null;
    refreshToken = null;
    userName = null;
    userEmail = null;
    userPhone = null;
    userLocation = null;
    userId = null;
    roles = [];
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userNameKey);
    await _secureStorage.delete(key: _userEmailKey);
    await _secureStorage.delete(key: _userPhoneKey);
    await _secureStorage.delete(key: _userLocationKey);
  }
}
