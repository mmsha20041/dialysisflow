import 'package:dialysisflow/features/auth/data/datasources/mock_auth_data_source.dart';
import 'package:dialysisflow/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._dataSource);

  final MockAuthDataSource _dataSource;

  @override
  Future<bool> signIn({required String email, required String password}) {
    return _dataSource.signIn(email: email, password: password);
  }
}
