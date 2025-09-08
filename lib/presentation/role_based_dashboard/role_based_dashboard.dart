import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_card_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/dashboard_stats_widget.dart';
import './widgets/notification_badge_widget.dart';
import './widgets/quick_action_fab_widget.dart';

class RoleBasedDashboard extends StatefulWidget {
  const RoleBasedDashboard({Key? key}) : super(key: key);

  @override
  State<RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends State<RoleBasedDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  String _currentUserRole = 'Staff';
  int _notificationCount = 5;

  // Mock user data
  final Map<String, dynamic> _currentUser = {
    "id": 1,
    "name": "Dr. Priya Sharma",
    "role": "RMO",
    "center": "Apollo Dialysis Center, Mumbai",
    "shift": "On Duty",
    "avatar":
        "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
  };

  // Mock dashboard data for different roles
  final Map<String, List<Map<String, dynamic>>> _roleBasedData = {
    "RMO": [
      {
        "title": "Pending Clinical Notes",
        "subtitle": "Awaiting your review and approval",
        "count": "12",
        "priority": "Urgent",
        "icon": "assignment_late",
      },
      {
        "title": "Discharge Approvals",
        "subtitle": "Patients ready for discharge",
        "count": "8",
        "priority": "Pending",
        "icon": "check_circle_outline",
      },
      {
        "title": "Lab Reports Review",
        "subtitle": "New reports for analysis",
        "count": "15",
        "priority": "Medium",
        "icon": "science",
      },
    ],
    "Staff": [
      {
        "title": "Active Sessions",
        "subtitle": "Currently ongoing dialysis sessions",
        "count": "24",
        "priority": "Urgent",
        "icon": "local_hospital",
      },
      {
        "title": "Patient Vitals",
        "subtitle": "Vitals monitoring required",
        "count": "18",
        "priority": "Pending",
        "icon": "favorite",
      },
      {
        "title": "Medication Due",
        "subtitle": "Scheduled drug administration",
        "count": "6",
        "priority": "Medium",
        "icon": "medication",
      },
    ],
    "Arogya Mitra": [
      {
        "title": "TMS Submissions",
        "subtitle": "Claims pending submission",
        "count": "32",
        "priority": "Urgent",
        "icon": "upload_file",
      },
      {
        "title": "Claim Status",
        "subtitle": "Awaiting government approval",
        "count": "45",
        "priority": "Pending",
        "icon": "pending_actions",
      },
      {
        "title": "Document Verification",
        "subtitle": "Files requiring validation",
        "count": "9",
        "priority": "Medium",
        "icon": "verified",
      },
    ],
    "Admin": [
      {
        "title": "Center Analytics",
        "subtitle": "Performance metrics overview",
        "count": "3",
        "priority": "Medium",
        "icon": "analytics",
      },
      {
        "title": "Staff Management",
        "subtitle": "Team scheduling and assignments",
        "count": "28",
        "priority": "Pending",
        "icon": "group",
      },
      {
        "title": "System Alerts",
        "subtitle": "Technical issues and updates",
        "count": "5",
        "priority": "Urgent",
        "icon": "warning",
      },
    ],
  };

  // Mock stats data
  final List<Map<String, dynamic>> _todayStats = [
    {"label": "Total Patients", "value": "156"},
    {"label": "Active Sessions", "value": "24"},
    {"label": "Completed", "value": "89"},
    {"label": "Pending Claims", "value": "32"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _currentUserRole = (_currentUser['role'] as String?) ?? 'Staff';
    _simulateDataRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _notificationCount = (_notificationCount + 1) % 10;
    });

    // Show success feedback
    HapticFeedback.selectionClick();
  }

  void _simulateDataRefresh() {
    // Simulate automatic refresh every 30 seconds
    Future.delayed(Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _notificationCount = (_notificationCount + 1) % 15;
        });
        _simulateDataRefresh();
      }
    });
  }

  void _handleCardTap(Map<String, dynamic> cardData) {
    // Navigate based on card type
    final title = cardData['title'] as String;

    if (title.contains('Patient')) {
      Navigator.pushNamed(context, '/patient-list');
    } else if (title.contains('Session')) {
      Navigator.pushNamed(context, '/patient-detail');
    } else if (title.contains('Clinical') || title.contains('Review')) {
      Navigator.pushNamed(context, '/patient-detail');
    } else {
      // Default navigation
      Navigator.pushNamed(context, '/patient-list');
    }
  }

  void _handleCardLongPress(Map<String, dynamic> cardData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.getStatusColor('success'),
                size: 24,
              ),
              title: Text('Mark Complete'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'assignment_ind',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Reassign'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.selectionClick();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _handleCardTap(cardData);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleQuickAction() {
    switch (_currentUserRole.toLowerCase()) {
      case 'staff':
      case 'nurse':
        Navigator.pushNamed(context, '/patient-registration');
        break;
      case 'rmo':
      case 'doctor':
        Navigator.pushNamed(context, '/patient-detail');
        break;
      case 'arogya mitra':
        Navigator.pushNamed(context, '/patient-list');
        break;
      case 'admin':
        Navigator.pushNamed(context, '/patient-list');
        break;
      default:
        Navigator.pushNamed(context, '/patient-list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoleData = _roleBasedData[_currentUserRole] ?? [];

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          DashboardHeaderWidget(
            userName: (_currentUser['name'] as String?) ?? 'User',
            centerLocation:
                (_currentUser['center'] as String?) ?? 'Unknown Center',
            shiftStatus: (_currentUser['shift'] as String?) ?? 'Off Duty',
            userRole: _currentUserRole,
          ),
          Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: AppTheme.lightTheme.primaryColor,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              indicatorColor: AppTheme.lightTheme.primaryColor,
              indicatorWeight: 3,
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle:
                  AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'Patients'),
                Tab(text: 'Sessions'),
                Tab(text: 'Reports'),
                Tab(
                  child: NotificationBadgeWidget(
                    count: _notificationCount,
                    child: Text('Profile'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Dashboard Tab
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: AppTheme.lightTheme.primaryColor,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        DashboardStatsWidget(stats: _todayStats),
                        SizedBox(height: 1.h),
                        if (_isRefreshing)
                          Container(
                            padding: EdgeInsets.all(2.h),
                            child: CircularProgressIndicator(
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: currentRoleData.length,
                            itemBuilder: (context, index) {
                              final cardData = currentRoleData[index];
                              return DashboardCardWidget(
                                title: (cardData['title'] as String?) ?? '',
                                subtitle:
                                    (cardData['subtitle'] as String?) ?? '',
                                count: (cardData['count'] as String?) ?? '0',
                                priority: (cardData['priority'] as String?) ??
                                    'Medium',
                                iconName:
                                    (cardData['icon'] as String?) ?? 'info',
                                onTap: () => _handleCardTap(cardData),
                                onLongPress: () =>
                                    _handleCardLongPress(cardData),
                              );
                            },
                          ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                // Patients Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'people',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Patients Management',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/patient-list'),
                        child: Text('View Patient List'),
                      ),
                    ],
                  ),
                ),
                // Sessions Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'local_hospital',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Session Management',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/patient-detail'),
                        child: Text('View Active Sessions'),
                      ),
                    ],
                  ),
                ),
                // Reports Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'assessment',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Reports & Analytics',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/patient-list'),
                        child: Text('Generate Reports'),
                      ),
                    ],
                  ),
                ),
                // Profile Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (_currentUser['name'] as String?)?.isNotEmpty ==
                                    true
                                ? (_currentUser['name'] as String)[0]
                                    .toUpperCase()
                                : 'U',
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        (_currentUser['name'] as String?) ?? 'User',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _currentUserRole,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/login-screen'),
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? QuickActionFabWidget(
              userRole: _currentUserRole,
              onPressed: _handleQuickAction,
            )
          : null,
    );
  }
}
