import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getProfile();
  Future<User> updateProfile({String? name, String? bio});
}
