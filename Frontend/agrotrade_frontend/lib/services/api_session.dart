class ApiSession {
  ApiSession._();

  static final ApiSession instance = ApiSession._();

  String? token;
  String? userName;
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
  }

  void clear() {
    token = null;
    userName = null;
    roles = [];
  }
}

