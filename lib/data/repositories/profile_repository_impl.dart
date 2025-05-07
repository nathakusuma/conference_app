import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<User> updateProfile({String? name, String? bio}) async {
    return await remoteDataSource.updateProfile(name: name, bio: bio);
  }
}
