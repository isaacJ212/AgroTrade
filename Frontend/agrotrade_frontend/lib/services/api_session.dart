class ApiSession {
  ApiSession._();

  static final ApiSession instance = ApiSession._();

  String? token;
  String? userName;

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  void setAuth({
    required String token,
    String? userName,
  }) {
    this.token = token;
    this.userName = userName;
  }

  void clear() {
    token = null;
    userName = null;
  }
}

