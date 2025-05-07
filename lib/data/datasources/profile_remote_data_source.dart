import '../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({String? name, String? bio});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getProfile() async {
    final response = await client.get(
      '/users/me',
      requireAuth: true,
    );
    return UserModel.fromJson(response['user']);
  }

  @override
  Future<UserModel> updateProfile({String? name, String? bio}) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (bio != null) data['bio'] = bio;

    // PATCH returns 204, so we will ignore result, then GET the new data.
    await client.patch(
      '/users/me',
      data: data,
      requireAuth: true,
    );
    return await getProfile();
  }
}
