import '../../repositories/auth_repository.dart';

class RequestResetPasswordOtp {
  final AuthRepository repository;

  RequestResetPasswordOtp(this.repository);

  Future<void> call(String email) {
    return repository.requestResetPasswordOtp(email);
  }
}
