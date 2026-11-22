class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    this.fullName,
  });

  final String id;
  final String email;
  final String role;
  final bool isActive;
  final String? fullName;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'student',
      isActive: json['is_active'] as bool? ?? true,
      fullName: json['full_name'] as String?,
    );
  }
}
