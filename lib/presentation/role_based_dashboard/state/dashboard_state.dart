class DashboardViewData {
  const DashboardViewData({
    this.currentUser = const {},
    this.roleBasedData = const {},
    this.todayStats = const [],
    this.currentUserRole = 'Staff',
    this.notificationCount = 0,
    this.isRefreshing = false,
  });

  final Map<String, dynamic> currentUser;
  final Map<String, List<Map<String, dynamic>>> roleBasedData;
  final List<Map<String, dynamic>> todayStats;
  final String currentUserRole;
  final int notificationCount;
  final bool isRefreshing;

  List<Map<String, dynamic>> get currentRoleData =>
      roleBasedData[currentUserRole] ?? const [];

  DashboardViewData copyWith({
    Map<String, dynamic>? currentUser,
    Map<String, List<Map<String, dynamic>>>? roleBasedData,
    List<Map<String, dynamic>>? todayStats,
    String? currentUserRole,
    int? notificationCount,
    bool? isRefreshing,
  }) {
    return DashboardViewData(
      currentUser: currentUser ?? this.currentUser,
      roleBasedData: roleBasedData ?? this.roleBasedData,
      todayStats: todayStats ?? this.todayStats,
      currentUserRole: currentUserRole ?? this.currentUserRole,
      notificationCount: notificationCount ?? this.notificationCount,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

sealed class DashboardState {
  const DashboardState(this.data);

  final DashboardViewData data;
}

class DashboardEmpty extends DashboardState {
  const DashboardEmpty([super.data = const DashboardViewData()]);
}

class DashboardLoading extends DashboardState {
  const DashboardLoading(super.data);
}

class DashboardSuccess extends DashboardState {
  const DashboardSuccess(super.data, {this.message});

  final String? message;
}

class DashboardError extends DashboardState {
  const DashboardError(super.data, this.message);

  final String message;
}
