import 'package:dialysisflow/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  GetDashboardDataUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Map<String, dynamic>> getCurrentUser() => _repository.getCurrentUser();

  Future<Map<String, List<Map<String, dynamic>>>> getRoleBasedCards() =>
      _repository.getRoleBasedCards();
}
