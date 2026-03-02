import '../entities/session.dart';

abstract class AuthRepository {
  Future<Session> createSession({required String email, required String password});

  Future<void> revokeSession();
}
