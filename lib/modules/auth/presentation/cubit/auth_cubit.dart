import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/data/repository/auth_repository.dart';
import 'package:moto_slot/modules/auth/domain/model/app_user.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState());

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _emitAuthenticatedState(user);
      } else {
        emit(state.copyWith(status: StateStatus.success, clearUser: true));
      }
    } catch (e) {
      emit(state.copyWith(status: StateStatus.success, clearUser: true));
    }
  }

  // ── Email Link ─────────────────────────────────────────

  Future<void> sendSignInLink(String email) async {
    emit(state.copyWith(
      status: StateStatus.loading,
      clearError: true,
      isEmailLinkSent: false,
    ));
    try {
      await _authRepository.sendSignInLink(email);
      emit(state.copyWith(
        status: StateStatus.success,
        isEmailLinkSent: true,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'unexpectedError',
      ));
    }
  }

  Future<void> signInWithEmailLink(String emailLink) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final user = await _authRepository.signInWithEmailLink(emailLink);
      _emitAuthenticatedState(user);
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'unexpectedError',
      ));
    }
  }

  // ── Social Auth ────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final user = await _authRepository.signInWithGoogle();
      _emitAuthenticatedState(user);
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'unexpectedError',
      ));
    }
  }

  Future<void> signInWithApple() async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final user = await _authRepository.signInWithApple();
      _emitAuthenticatedState(user);
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'unexpectedError',
      ));
    }
  }

  // ── Profile Completion ─────────────────────────────────

  Future<void> completeProfile({
    required String fullName,
    String? phone,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final userId = state.user?.id;
      if (userId == null) {
        throw const AuthException(message: 'User not found.');
      }
      final updatedUser = await _authRepository.updateUserProfile(
        userId: userId,
        fullName: fullName,
        phone: phone,
      );
      emit(state.copyWith(
        status: StateStatus.success,
        user: updatedUser,
        needsProfileCompletion: false,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'unexpectedError',
      ));
    }
  }

  // ── Shared ─────────────────────────────────────────────

  void _emitAuthenticatedState(AppUser user) {
    if (!user.isProfileComplete) {
      emit(state.copyWith(
        status: StateStatus.success,
        user: user,
        needsProfileCompletion: true,
      ));
    } else {
      emit(state.copyWith(
        status: StateStatus.success,
        user: user,
        needsProfileCompletion: false,
      ));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const AuthState(status: StateStatus.success));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
