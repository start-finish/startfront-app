import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  AuthNotifier() : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty) {
      state = AuthState(isAuthenticated: true, email: email);
      return true;
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  Future<bool> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty) {
      state = AuthState(isAuthenticated: true, email: email);
      return true;
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
