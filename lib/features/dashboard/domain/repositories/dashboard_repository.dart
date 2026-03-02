abstract class DashboardRepository {
  Future<Map<String, dynamic>> getCurrentUser();
  Future<Map<String, List<Map<String, dynamic>>>> getRoleBasedCards();
}
