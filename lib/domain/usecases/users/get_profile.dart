import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class GetProfile {
  final UserRepository repository;
  GetProfile(this.repository);

  Future<User> call() {
    return repository.getProfile();
  }
}
