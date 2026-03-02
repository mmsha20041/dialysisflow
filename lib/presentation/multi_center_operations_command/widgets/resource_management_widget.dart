import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';
import '../../../theme/app_theme.dart';

class ResourceManagementWidget extends StatefulWidget {
  final String selectedCenter;

  const ResourceManagementWidget({
    super.key,
    required this.selectedCenter,
  });

  @override
  State<ResourceManagementWidget> createState() =>
      _ResourceManagementWidgetState();
}

class _ResourceManagementWidgetState extends State<ResourceManagementWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-tabs for Resource Management
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.primaryLight,
            labelColor: AppTheme.primaryLight,
            unselectedLabelColor: AppTheme.textSecondaryLight,
            labelStyle: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Staff Scheduling'),
              Tab(text: 'Shortage Alerts'),
              Tab(text: 'Optimization'),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStaffSchedulingTab(),
              _buildShortageAlertsTab(),
              _buildOptimizationTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStaffSchedulingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Staff Scheduling Overview',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackgroundLight,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showScheduleDialog(),
                    icon: Icon(Icons.add, color: AppTheme.primaryLight),
                    tooltip: 'Add Schedule',
                  ),
                  IconButton(
                    onPressed: () => _exportSchedule(),
                    icon: Icon(Icons.download, color: AppTheme.primaryLight),
                    tooltip: 'Export Schedule',
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  'Total Staff',
                  '286',
                  Icons.people,
                  AppTheme.primaryLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildQuickStatCard(
                  'On Duty',
                  '142',
                  Icons.work,
                  AppTheme.successLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildQuickStatCard(
                  'Available',
                  '89',
                  Icons.check_circle,
                  AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildQuickStatCard(
                  'Off Duty',
                  '55',
                  Icons.home,
                  AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Schedule Calendar/Grid
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Schedule',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildScheduleGrid(),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Staff List with Current Status
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Staff Status',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildStaffList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortageAlertsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alert Summary
          Row(
            children: [
              Expanded(
                child: Card(
                  color: AppTheme.errorLight.withValues(alpha: 0.1),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning,
                          color: AppTheme.errorLight,
                          size: 24.sp,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '5',
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.errorLight,
                          ),
                        ),
                        Text(
                          'Critical Shortages',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: AppTheme.errorLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Card(
                  color: AppTheme.warningLight.withValues(alpha: 0.1),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info,
                          color: AppTheme.warningLight,
                          size: 24.sp,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '12',
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.warningLight,
                          ),
                        ),
                        Text(
                          'Moderate Alerts',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: AppTheme.warningLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Shortage Alerts List
          Text(
            'Active Shortage Alerts',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.onBackgroundLight,
            ),
          ),

          SizedBox(height: 2.h),

          _buildShortageAlertCard(
            'Downtown Center',
            'Nursing Staff Shortage',
            'Critical: 3 nurses short for night shift',
            AppTheme.errorLight,
            '2 hours ago',
          ),

          _buildShortageAlertCard(
            'Northside Clinic',
            'Technician Coverage Gap',
            'Moderate: 1 technician needed for weekend',
            AppTheme.warningLight,
            '4 hours ago',
          ),

          _buildShortageAlertCard(
            'Eastside Facility',
            'Administrative Support',
            'Low: Reception desk understaffed',
            AppTheme.warningLight,
            '6 hours ago',
          ),

          SizedBox(height: 3.h),

          // Quick Actions
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _sendEmergencyStaffRequest(),
                          icon: Icon(Icons.emergency),
                          label: Text('Emergency Staff Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorLight,
                            foregroundColor: AppTheme.onErrorLight,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showStaffPool(),
                          icon: Icon(Icons.people_alt),
                          label: Text('View Staff Pool'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optimization Overview
          Text(
            'Automated Optimization Suggestions',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.onBackgroundLight,
            ),
          ),

          SizedBox(height: 2.h),

          // AI-Powered Suggestions
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.smart_toy,
                        color: AppTheme.primaryLight,
                        size: 16.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'AI Recommendations',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onBackgroundLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildOptimizationSuggestion(
                    'Staff Reallocation',
                    'Move 2 nurses from Midtown Unit to Downtown Center during peak hours',
                    'Efficiency increase: +12%',
                    AppTheme.successLight,
                  ),
                  _buildOptimizationSuggestion(
                    'Shift Adjustment',
                    'Extend morning shift by 30 minutes to reduce handover gaps',
                    'Patient wait time: -8%',
                    AppTheme.primaryLight,
                  ),
                  _buildOptimizationSuggestion(
                    'Cross-Training',
                    'Train 5 staff members in multiple specialties for flexibility',
                    'Coverage improvement: +15%',
                    AppTheme.warningLight,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Optimization Metrics
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optimization Metrics',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Efficiency Score',
                          '87%',
                          Icons.speed,
                          AppTheme.successLight,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildMetricCard(
                          'Cost Savings',
                          '\$12.4K',
                          Icons.savings,
                          AppTheme.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Coverage Rate',
                          '94%',
                          Icons.shield,
                          AppTheme.warningLight,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildMetricCard(
                          'Satisfaction',
                          '91%',
                          Icons.sentiment_satisfied,
                          AppTheme.successLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Optimization Controls
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optimization Controls',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SwitchListTile(
                    title: Text(
                      'Auto-Optimize Schedules',
                      style: GoogleFonts.inter(fontSize: 12.sp),
                    ),
                    subtitle: Text(
                      'Automatically apply AI suggestions',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    value: true,
                    onChanged: (value) {
                      // Handle auto-optimize toggle
                    },
                  ),
                  SwitchListTile(
                    title: Text(
                      'Real-time Adjustments',
                      style: GoogleFonts.inter(fontSize: 12.sp),
                    ),
                    subtitle: Text(
                      'Adjust staffing based on demand',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    value: false,
                    onChanged: (value) {
                      // Handle real-time toggle
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(2.w),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(height: 1.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.onBackgroundLight,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGrid() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final shifts = ['Morning', 'Afternoon', 'Night'];

    return Column(
      children: [
        // Header row
        Row(
          children: [
            SizedBox(width: 15.w),
            ...days
                .map((day) => Expanded(
                      child: Text(
                        day,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onBackgroundLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ],
        ),
        SizedBox(height: 1.h),
        // Schedule rows
        ...shifts
            .map((shift) => Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15.w,
                        child: Text(
                          shift,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ),
                      ...List.generate(
                          7,
                          (index) => Expanded(
                                child: Container(
                                  height: 4.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 0.5.w),
                                  decoration: BoxDecoration(
                                    color: _getScheduleColor(shift, index),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getStaffCount(shift, index),
                                      style: GoogleFonts.inter(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.backgroundLight,
                                      ),
                                    ),
                                  ),
                                ),
                              )).toList(),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Color _getScheduleColor(String shift, int day) {
    // Simulate different staffing levels with colors
    final random = (shift.hashCode + day) % 3;
    switch (random) {
      case 0:
        return AppTheme.successLight; // Well staffed
      case 1:
        return AppTheme.warningLight; // Adequate
      default:
        return AppTheme.errorLight; // Understaffed
    }
  }

  String _getStaffCount(String shift, int day) {
    // Simulate staff counts
    final base = shift == 'Morning' ? 8 : (shift == 'Afternoon' ? 6 : 4);
    final variation = (shift.hashCode + day) % 3;
    return (base + variation).toString();
  }

  Widget _buildStaffList() {
    final staff = [
      {
        'name': 'Dr. Sarah Johnson',
        'role': 'Nephrologist',
        'status': 'On Duty',
        'center': 'Downtown'
      },
      {
        'name': 'Nurse Maria Garcia',
        'role': 'RN',
        'status': 'Available',
        'center': 'Northside'
      },
      {
        'name': 'Tech John Smith',
        'role': 'Dialysis Tech',
        'status': 'On Break',
        'center': 'Downtown'
      },
      {
        'name': 'Dr. Michael Chen',
        'role': 'Nephrologist',
        'status': 'Off Duty',
        'center': 'Eastside'
      },
    ];

    return Column(
      children: staff
          .map((person) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(person['status']!),
                  child: Text(
                    person['name']![0],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.backgroundLight,
                    ),
                  ),
                ),
                title: Text(
                  person['name']!,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${person['role']} • ${person['center']} Center',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                trailing: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(person['status']!)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    person['status']!,
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(person['status']!),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'On Duty':
        return AppTheme.successLight;
      case 'Available':
        return AppTheme.primaryLight;
      case 'On Break':
        return AppTheme.warningLight;
      case 'Off Duty':
        return AppTheme.textSecondaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  Widget _buildShortageAlertCard(String center, String title,
      String description, Color color, String time) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: color,
                  size: 16.sp,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              center,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Handle resolve action
                  },
                  child: Text('Resolve'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle view details
                  },
                  child: Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationSuggestion(
      String title, String description, String benefit, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.onBackgroundLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                benefit,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Apply suggestion
                    },
                    child: Text('Apply'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Dismiss suggestion
                    },
                    child: Text('Dismiss'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(2.w),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(height: 1.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.onBackgroundLight,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Schedule'),
        content: Text('Schedule management dialog would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _exportSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Schedule exported successfully')),
    );
  }

  void _sendEmergencyStaffRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Emergency staff request sent to all available personnel'),
        backgroundColor: AppTheme.errorLight,
      ),
    );
  }

  void _showStaffPool() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 40.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Staff Pool',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Dr. Amanda Rodriguez'),
                    subtitle: Text('Nephrologist • Available'),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: Text('Assign'),
                    ),
                  ),
                  ListTile(
                    title: Text('Nurse David Kim'),
                    subtitle: Text('RN • Available'),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: Text('Assign'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
