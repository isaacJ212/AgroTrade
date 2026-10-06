class UserRoutes {
  static const String base = '/api/Users';

  static String byId(int id) => '$base/$id';
  static String byEmail(String email) =>
      '$base/email?email=${Uri.encodeComponent(email)}';
  static String updatePassword(int id) => '$base/$id/Password';
  static String sendPasswordCode(int id) => '$base/$id/password/send-code';
  static String verifyPasswordCode(int id) => '$base/$id/password/verify-code';
  static String resetPassword(int id) => '$base/$id/password/reset';
  static const String sendPasswordRecoveryCode =
      '$base/password/recovery/send-code';
  static const String verifyPasswordRecoveryCode =
      '$base/password/recovery/verify-code';
  static const String resetPasswordRecovery = '$base/password/recovery/reset';
}
