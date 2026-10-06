class UserRoutes {
  static const String base = '/api/Users';

  static String byId(int id) => '$base/$id';
  static String byEmail(String email) => '$base/email?email=${Uri.encodeComponent(email)}';
  static String updatePassword(int id) => '$base/$id/Password';
}
