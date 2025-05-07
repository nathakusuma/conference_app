import '../../../../core/utils/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<void> requestRegisterOtp(String email) async {
    await remoteDataSource.requestRegisterOtp(email);
  }

  @override
  Future<void> verifyRegisterOtp(String email, String otp) async {
    await remoteDataSource.verifyRegisterOtp(email, otp);
  }

  @override
  Future<AuthTokens> register(
      String email,
      String otp,
      String name,
      String password,
      ) async {
    final authTokens = await remoteDataSource.register(
      email,
      otp,
      name,
      password,
    );

    // Save tokens to secure storage
    await tokenStorage.saveTokens(
      accessToken: authTokens.accessToken,
      refreshToken: authTokens.refreshToken,
    );

    return authTokens;
  }

  @override
  Future<AuthTokens> login(String email, String password) async {
    final authTokens = await remoteDataSource.login(email, password);

    // Save tokens to secure storage
    await tokenStorage.saveTokens(
      accessToken: authTokens.accessToken,
      refreshToken: authTokens.refreshToken,
    );

    return authTokens;
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    final authTokens = await remoteDataSource.refreshToken(refreshToken);

    // Save tokens to secure storage
    await tokenStorage.saveTokens(
      accessToken: authTokens.accessToken,
      refreshToken: authTokens.refreshToken,
    );

    return authTokens;
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } finally {
      // Always clear tokens even if logout API call fails
      await tokenStorage.clearTokens();
    }
  }

  @override
  Future<void> requestResetPasswordOtp(String email) async {
    await remoteDataSource.requestResetPasswordOtp(email);
  }

  @override
  Future<AuthTokens> resetPassword(
      String email,
      String otp,
      String newPassword,
      ) async {
    final authTokens = await remoteDataSource.resetPassword(
      email,
      otp,
      newPassword,
    );

    // Save tokens to secure storage
    await tokenStorage.saveTokens(
      accessToken: authTokens.accessToken,
      refreshToken: authTokens.refreshToken,
    );

    return authTokens;
  }
}
