import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_state.dart';

final dashboardControllerProvider =
    StateNotifierProvider.autoDispose<DashboardController, DashboardState>(
  (ref) => DashboardController()..initialize(),
);

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(const DashboardEmpty());

  Timer? _notificationTimer;

  void initialize() {
    state = DashboardLoading(state.data);

    const currentUser = {
      'id': 1,
      'name': 'Dr. Priya Sharma',
      'role': 'RMO',
      'center': 'Apollo Dialysis Center, Mumbai',
      'shift': 'On Duty',
      'avatar':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
    };

    const roleBasedData = {
      'RMO': [
        {
          'title': 'Pending Clinical Notes',
          'subtitle': 'Awaiting your review and approval',
          'count': '12',
          'priority': 'Urgent',
          'icon': 'assignment_late',
        },
        {
          'title': 'Discharge Approvals',
          'subtitle': 'Patients ready for discharge',
          'count': '8',
          'priority': 'Pending',
          'icon': 'check_circle_outline',
        },
      ],
      'Staff': [
        {
          'title': 'Active Sessions',
          'subtitle': 'Currently ongoing dialysis sessions',
          'count': '24',
          'priority': 'Urgent',
          'icon': 'local_hospital',
        },
      ],
      'Arogya Mitra': [
        {
          'title': 'TMS Submissions',
          'subtitle': 'Claims pending submission',
          'count': '32',
          'priority': 'Urgent',
          'icon': 'upload_file',
        },
      ],
      'Admin': [
        {
          'title': 'Center Analytics',
          'subtitle': 'Performance metrics overview',
          'count': '3',
          'priority': 'Medium',
          'icon': 'analytics',
        },
      ],
    };

    const todayStats = [
      {'label': 'Total Patients', 'value': '156'},
      {'label': 'Active Sessions', 'value': '24'},
      {'label': 'Completed', 'value': '89'},
      {'label': 'Pending Claims', 'value': '32'},
    ];

    final data = DashboardViewData(
      currentUser: currentUser,
      roleBasedData: roleBasedData,
      todayStats: todayStats,
      currentUserRole: (currentUser['role'] as String?) ?? 'Staff',
      notificationCount: 5,
    );

    if (data.currentRoleData.isEmpty) {
      state = DashboardEmpty(data);
    } else {
      state = DashboardSuccess(data);
    }

    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final count = (state.data.notificationCount + 1) % 15;
      state = DashboardSuccess(state.data.copyWith(notificationCount: count));
    });
  }

  Future<void> refresh() async {
    if (state.data.isRefreshing) return;

    state = DashboardLoading(state.data.copyWith(isRefreshing: true));
    await Future.delayed(const Duration(seconds: 2));

    final count = (state.data.notificationCount + 1) % 10;
    final data = state.data.copyWith(
      isRefreshing: false,
      notificationCount: count,
    );

    if (data.currentRoleData.isEmpty) {
      state = DashboardEmpty(data);
    } else {
      state = DashboardSuccess(data, message: 'Dashboard refreshed');
    }
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }
}
