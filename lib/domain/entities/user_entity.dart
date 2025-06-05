class UserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? role;
  final String? token;

  UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.role,
    this.token,
  });
}
