import 'package:dialysisflow/features/dashboard/data/datasources/mock_dashboard_data_source.dart';
import 'package:dialysisflow/features/dashboard/domain/repositories/dashboard_repository.dart';

class MockDashboardRepository implements DashboardRepository {
  MockDashboardRepository(this._dataSource);

  final MockDashboardDataSource _dataSource;

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    return _dataSource.fetchCurrentUser();
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> getRoleBasedCards() async {
    return _dataSource.fetchRoleBasedCards();
  }
}
