import '../../../../core/network/api_client.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestRegisterOtp(String email);
  Future<void> verifyRegisterOtp(String email, String otp);
  Future<AuthTokensModel> register(String email, String otp, String name, String password);
  Future<AuthTokensModel> login(String email, String password);
  Future<AuthTokensModel> refreshToken(String refreshToken);
  Future<void> logout();
  Future<void> requestResetPasswordOtp(String email);
  Future<AuthTokensModel> resetPassword(String email, String otp, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> requestRegisterOtp(String email) async {
    await client.post(
      '/auth/register/otp',
      data: {'email': email},
    );
  }

  @override
  Future<void> verifyRegisterOtp(String email, String otp) async {
    await client.post(
      '/auth/register/otp/check',
      data: {'email': email, 'otp': otp},
    );
  }

  @override
  Future<AuthTokensModel> register(
      String email,
      String otp,
      String name,
      String password,
      ) async {
    final response = await client.post(
      '/auth/register',
      data: {
        'email': email,
        'otp': otp,
        'name': name,
        'password': password,
      },
    );
    return AuthTokensModel.fromJson(response);
  }

  @override
  Future<AuthTokensModel> login(String email, String password) async {
    final response = await client.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return AuthTokensModel.fromJson(response);
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final response = await client.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return AuthTokensModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await client.post(
      '/auth/logout',
      requireAuth: true,
    );
  }

  @override
  Future<void> requestResetPasswordOtp(String email) async {
    await client.post(
      '/auth/reset-password/otp',
      data: {'email': email},
    );
  }

  @override
  Future<AuthTokensModel> resetPassword(
      String email,
      String otp,
      String newPassword,
      ) async {
    final response = await client.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      },
    );
    return AuthTokensModel.fromJson(response);
  }
}
