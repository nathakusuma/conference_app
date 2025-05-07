enum UserRole { user, admin, eventCoordinator }

class User {
  final String? id;
  final String? name;
  final String? email;
  final UserRole? role;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });
}
