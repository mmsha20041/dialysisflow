class LoginViewData {
  const LoginViewData({
    this.showBiometric = false,
    this.failedAttempts = 0,
    this.isAccountLocked = false,
  });

  final bool showBiometric;
  final int failedAttempts;
  final bool isAccountLocked;

  LoginViewData copyWith({
    bool? showBiometric,
    int? failedAttempts,
    bool? isAccountLocked,
  }) {
    return LoginViewData(
      showBiometric: showBiometric ?? this.showBiometric,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      isAccountLocked: isAccountLocked ?? this.isAccountLocked,
    );
  }
}

sealed class LoginState {
  const LoginState(this.data);

  final LoginViewData data;
}

class LoginEmpty extends LoginState {
  const LoginEmpty([super.data = const LoginViewData()]);
}

class LoginLoading extends LoginState {
  const LoginLoading(super.data);
}

class LoginSuccess extends LoginState {
  const LoginSuccess(super.data, {this.message});

  final String? message;
}

class LoginError extends LoginState {
  const LoginError(super.data, this.message);

  final String message;
}
