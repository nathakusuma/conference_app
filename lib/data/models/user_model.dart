import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    super.name,
    super.email,
    super.role,
    super.bio,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserRole? parseRole(String? roleStr) {
      if (roleStr == null) return null;
      switch (roleStr) {
        case 'user':
          return UserRole.user;
        case 'admin':
          return UserRole.admin;
        case 'event_coordinator':
          return UserRole.eventCoordinator;
        default:
          return null;
      }
    }

    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: parseRole(json['role']),
      bio: json['bio'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    String? roleToString(UserRole? role) {
      if (role == null) return null;
      switch (role) {
        case UserRole.user:
          return 'user';
        case UserRole.admin:
          return 'admin';
        case UserRole.eventCoordinator:
          return 'event_coordinator';
      }
    }

    return {
      'id': id,
      'name': name,
      'email': email,
      'role': roleToString(role),
      'bio': bio,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
