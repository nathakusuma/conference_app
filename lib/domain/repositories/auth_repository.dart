import '../entities/user.dart';

abstract class AuthRepository {
  // Registration
  Future<void> requestRegisterOtp(String email);
  Future<void> verifyRegisterOtp(String email, String otp);
  Future<AuthTokens> register(String email, String otp, String name, String password);

  // Login
  Future<AuthTokens> login(String email, String password);

  // Token management
  Future<AuthTokens> refreshToken(String refreshToken);
  Future<void> logout();

  // Password reset
  Future<void> requestResetPasswordOtp(String email);
  Future<AuthTokens> resetPassword(String email, String otp, String newPassword);
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
