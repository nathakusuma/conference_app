import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<AuthTokens> call(String email, String otp, String newPassword) {
    return repository.resetPassword(email, otp, newPassword);
  }
}
