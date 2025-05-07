import '../../entities/user.dart';
import '../../repositories/profile_repository.dart';

class GetProfile {
  final UserRepository repository;
  GetProfile(this.repository);

  Future<User> call() {
    return repository.getProfile();
  }
}
