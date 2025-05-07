import '../../repositories/auth_repository.dart';

class RequestRegisterOtp {
  final AuthRepository repository;

  RequestRegisterOtp(this.repository);

  Future<void> call(String email) {
    return repository.requestRegisterOtp(email);
  }
}