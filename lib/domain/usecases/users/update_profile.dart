import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;
  UpdateProfile(this.repository);

  Future<User> call({required String name, String? bio}) {
    return repository.updateProfile(name: name, bio: bio);
  }
}
