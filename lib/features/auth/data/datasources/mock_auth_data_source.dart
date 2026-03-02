class MockAuthDataSource {
  Future<bool> signIn({required String email, required String password}) async {
    return password.isNotEmpty && email.contains('@');
  }
}
