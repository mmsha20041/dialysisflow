import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';
import 'login_state.dart';

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>(
  (ref) => LoginController(AuthService())..initialize(),
);

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._authService) : super(const LoginEmpty());

  final AuthService _authService;
  Timer? _biometricTimer;
  Timer? _unlockTimer;

  void initialize() {
    _biometricTimer?.cancel();
    _biometricTimer = Timer(const Duration(seconds: 2), () {
      final updated = state.data.copyWith(showBiometric: true);
      state = LoginSuccess(updated);
    });
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (state.data.isAccountLocked) {
      state = LoginError(
        state.data,
        'Account is temporarily locked. Please try again later.',
      );
      return;
    }

    state = LoginLoading(state.data);

    try {
      final response = await _authService.signIn(
        email: username.contains('@') ? username : '$username@dialysisflow.com',
        password: password,
      );

      if (response.user != null) {
        final resetData = state.data.copyWith(failedAttempts: 0);
        state = LoginSuccess(resetData, message: 'Login successful');
      } else {
        _emitInvalidCredentials();
      }
    } catch (_) {
      _emitInvalidCredentials();
    }
  }

  void _emitInvalidCredentials() {
    final failedAttempts = state.data.failedAttempts + 1;
    final locked = failedAttempts >= 3;
    final updatedData = state.data.copyWith(
      failedAttempts: failedAttempts,
      isAccountLocked: locked,
    );

    if (locked) {
      _unlockTimer?.cancel();
      _unlockTimer = Timer(const Duration(seconds: 30), () {
        final unlockedData = state.data.copyWith(
          isAccountLocked: false,
          failedAttempts: 0,
        );
        state = LoginEmpty(unlockedData);
      });
      state = LoginError(
        updatedData,
        'Account locked due to multiple failed attempts. Please try again in 30 seconds.',
      );
      return;
    }

    state = LoginError(
      updatedData,
      'Invalid credentials. Please check your email and password.',
    );
  }

  void completeBiometricLogin() {
    state = LoginSuccess(state.data, message: 'Biometric authentication successful');
  }

  @override
  void dispose() {
    _biometricTimer?.cancel();
    _unlockTimer?.cancel();
    super.dispose();
  }
}
