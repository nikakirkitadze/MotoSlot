import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? authProvider;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    required this.createdAt,
    this.updatedAt,
    this.authProvider,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isProfileComplete => fullName.isNotEmpty;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      authProvider: json['authProvider'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role == UserRole.admin ? 'admin' : 'user',
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'authProvider': authProvider,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    bool clearPhone = false,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authProvider,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: clearPhone ? null : (phone ?? this.phone),
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authProvider: authProvider ?? this.authProvider,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, fullName, phone, role, createdAt, updatedAt, authProvider];
}
