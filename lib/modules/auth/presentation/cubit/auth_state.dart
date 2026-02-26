import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/domain/model/app_user.dart';

class AuthState extends Equatable {
  final StateStatus status;
  final AppUser? user;
  final String? errorMessage;
  final bool isPasswordResetSent;

  const AuthState({
    this.status = StateStatus.initial,
    this.user,
    this.errorMessage,
    this.isPasswordResetSent = false,
  });

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.isAdmin ?? false;
  bool get isLoading => status == StateStatus.loading;

  AuthState copyWith({
    StateStatus? status,
    AppUser? user,
    String? errorMessage,
    bool? isPasswordResetSent,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isPasswordResetSent: isPasswordResetSent ?? this.isPasswordResetSent,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, isPasswordResetSent];
}
