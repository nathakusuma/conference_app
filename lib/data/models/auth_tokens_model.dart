import '../../domain/repositories/auth_repository.dart';
import 'user_model.dart';

class AuthTokensModel extends AuthTokens {
  AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required UserModel super.user,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': (user as UserModel).toJson(),
    };
  }
}
