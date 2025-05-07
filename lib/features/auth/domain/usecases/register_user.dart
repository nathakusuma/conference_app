import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<AuthTokens> call(String email, String otp, String name, String password) {
    return repository.register(email, otp, name, password);
  }
}
