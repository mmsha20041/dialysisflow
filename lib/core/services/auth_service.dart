class AuthResponse {
  AuthResponse({this.user});

  final Map<String, dynamic>? user;
}

class AuthService {
  bool isAuthenticated = false;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      isAuthenticated = true;
      return AuthResponse(user: {'email': email});
    }
    return AuthResponse();
  }
}
