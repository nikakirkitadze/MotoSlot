import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/data/repository/auth_repository.dart';
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
        emit(state.copyWith(status: StateStatus.success, user: user));
      } else {
        emit(state.copyWith(
          status: StateStatus.success,
          clearUser: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.success,
        clearUser: true,
      ));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: StateStatus.success, user: user));
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

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      emit(state.copyWith(status: StateStatus.success, user: user));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'registrationFailed',
      ));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(
      status: StateStatus.loading,
      clearError: true,
      isPasswordResetSent: false,
    ));
    try {
      await _authRepository.resetPassword(email);
      emit(state.copyWith(
        status: StateStatus.success,
        isPasswordResetSent: true,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'resetEmailFailed',
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
