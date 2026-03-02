import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/session_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Session> createSession({
    required String email,
    required String password,
  }) async {
    final dto = await _remoteDataSource.createSession(
      email: email,
      password: password,
    );
    return dto.toDomain();
  }

  @override
  Future<void> revokeSession() {
    return _remoteDataSource.revokeSession();
  }
}
