import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/base_service.dart';

class AuthState {
  final bool isAuthenticated;
  final String? email;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.email,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? email,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final baseService = _ref.read(baseServiceProvider);
      final response = await baseService.login(email, password);

      if (response != null) {
        state = AuthState(isAuthenticated: true, email: email);
        return true;
      }
    } catch (e) {
      developer.log('Login error: $e');
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final baseService = _ref.read(baseServiceProvider);
      final response = await baseService.signUp(
        username: name,
        email: email,
        password: password,
      );

      if (response != null) {
        state = AuthState(isAuthenticated: true, email: email);
        return true;
      }
    } catch (e) {
      developer.log('Signup error: $e');
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
