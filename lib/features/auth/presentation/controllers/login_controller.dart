import 'package:dialysisflow/features/auth/domain/repositories/auth_repository.dart';

class LoginController {
  LoginController(this._repository);

  final AuthRepository _repository;

  Future<bool> signIn({required String username, required String password}) {
    return _repository.signIn(
      email: username.contains('@') ? username : '$username@dialysisflow.com',
      password: password,
    );
  }
}
