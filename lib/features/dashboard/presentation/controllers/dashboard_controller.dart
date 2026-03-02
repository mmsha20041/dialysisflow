import 'package:dialysisflow/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardController {
  DashboardController(this._repository);

  final DashboardRepository _repository;

  Future<Map<String, dynamic>> loadCurrentUser() => _repository.getCurrentUser();

  Future<Map<String, List<Map<String, dynamic>>>> loadRoleBasedCards() =>
      _repository.getRoleBasedCards();
}
