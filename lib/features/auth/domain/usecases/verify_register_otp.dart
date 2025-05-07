import '../repositories/auth_repository.dart';

class VerifyRegisterOtp {
  final AuthRepository repository;

  VerifyRegisterOtp(this.repository);

  Future<void> call(String email, String otp) {
    return repository.verifyRegisterOtp(email, otp);
  }
}
