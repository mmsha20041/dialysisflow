import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './state/dashboard_controller.dart';
import './state/dashboard_state.dart';
import './widgets/dashboard_card_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/dashboard_stats_widget.dart';
import './widgets/notification_badge_widget.dart';
import './widgets/quick_action_fab_widget.dart';

class RoleBasedDashboard extends ConsumerStatefulWidget {
  const RoleBasedDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends ConsumerState<RoleBasedDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DashboardState>(dashboardControllerProvider, (previous, next) {
      if (next is DashboardSuccess && next.message == 'Dashboard refreshed') {
        HapticFeedback.selectionClick();
      }
    });

    final state = ref.watch(dashboardControllerProvider);
    final data = state.data;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          DashboardHeaderWidget(
            userName: (data.currentUser['name'] as String?) ?? 'User',
            centerLocation:
                (data.currentUser['center'] as String?) ?? 'Unknown Center',
            shiftStatus: (data.currentUser['shift'] as String?) ?? 'Off Duty',
            userRole: data.currentUserRole,
          ),
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: [
                const Tab(text: 'Dashboard'),
                const Tab(text: 'Patients'),
                const Tab(text: 'Sessions'),
                const Tab(text: 'Reports'),
                Tab(
                  child: NotificationBadgeWidget(
                    count: data.notificationCount,
                    child: const Text('Profile'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () => ref
                      .read(dashboardControllerProvider.notifier)
                      .refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        DashboardStatsWidget(stats: data.todayStats),
                        SizedBox(height: 1.h),
                        if (state is DashboardLoading && data.currentRoleData.isEmpty)
                          Container(
                            padding: EdgeInsets.all(2.h),
                            child: CircularProgressIndicator(
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          )
                        else if (state is DashboardEmpty)
                          Padding(
                            padding: EdgeInsets.all(6.w),
                            child: const Text('No dashboard tasks available.'),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.currentRoleData.length,
                            itemBuilder: (context, index) {
                              final cardData = data.currentRoleData[index];
                              return DashboardCardWidget(
                                title: (cardData['title'] as String?) ?? '',
                                subtitle: (cardData['subtitle'] as String?) ?? '',
                                count: (cardData['count'] as String?) ?? '0',
                                priority:
                                    (cardData['priority'] as String?) ?? 'Medium',
                                iconName: (cardData['icon'] as String?) ?? 'info',
                                onTap: () => _handleCardTap(cardData),
                                onLongPress: () => _handleCardLongPress(cardData),
                              );
                            },
                          ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                _tabPlaceholder('Patients Management', 'people', '/patient-list',
                    'View Patient List'),
                _tabPlaceholder('Session Management', 'local_hospital',
                    '/patient-detail', 'View Active Sessions'),
                _tabPlaceholder('Reports & Analytics', 'assessment',
                    '/patient-list', 'Generate Reports'),
                _profileTab(data),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? QuickActionFabWidget(
              userRole: data.currentUserRole,
              onPressed: () => _handleQuickAction(data.currentUserRole),
            )
          : null,
    );
  }

  Widget _tabPlaceholder(
      String title, String icon, String routeName, String buttonText) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(title, style: AppTheme.lightTheme.textTheme.titleMedium),
          SizedBox(height: 1.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, routeName),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _profileTab(DashboardViewData data) {
    final name = (data.currentUser['name'] as String?) ?? 'User';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: AppTheme.lightTheme.textTheme.titleLarge),
          SizedBox(height: 1.h),
          Text(data.currentUserRole),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login-screen'),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _handleCardTap(Map<String, dynamic> cardData) {
    final title = cardData['title'] as String;
    if (title.contains('Patient')) {
      Navigator.pushNamed(context, '/patient-list');
    } else {
      Navigator.pushNamed(context, '/patient-detail');
    }
  }

  void _handleCardLongPress(Map<String, dynamic> cardData) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListTile(
        title: const Text('View Details'),
        onTap: () {
          Navigator.pop(context);
          _handleCardTap(cardData);
        },
      ),
    );
  }

  void _handleQuickAction(String userRole) {
    switch (userRole.toLowerCase()) {
      case 'staff':
      case 'nurse':
        Navigator.pushNamed(context, '/patient-registration');
        break;
      default:
        Navigator.pushNamed(context, '/patient-list');
    }
  }
}
