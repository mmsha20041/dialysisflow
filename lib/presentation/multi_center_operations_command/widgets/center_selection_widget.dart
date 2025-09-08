import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CenterSelectionWidget extends StatefulWidget {
  final String selectedCenter;
  final Function(String) onCenterSelected;

  const CenterSelectionWidget({
    super.key,
    required this.selectedCenter,
    required this.onCenterSelected,
  });

  @override
  State<CenterSelectionWidget> createState() => _CenterSelectionWidgetState();
}

class _CenterSelectionWidgetState extends State<CenterSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<CenterInfo> _centers = [
    CenterInfo('All Centers', 'all', 3847, 24, CenterStatus.operational),
    CenterInfo(
        'Downtown Center', 'downtown', 180, 24, CenterStatus.operational),
    CenterInfo(
        'Northside Clinic', 'northside', 145, 18, CenterStatus.operational),
    CenterInfo('Westside Branch', 'westside', 0, 0, CenterStatus.maintenance),
    CenterInfo(
        'Eastside Facility', 'eastside', 167, 22, CenterStatus.operational),
    CenterInfo('Southside Center', 'southside', 89, 16, CenterStatus.critical),
    CenterInfo('Midtown Unit', 'midtown', 203, 28, CenterStatus.operational),
    CenterInfo(
        'Riverside Clinic', 'riverside', 156, 20, CenterStatus.operational),
    CenterInfo(
        'Hillside Branch', 'hillside', 134, 19, CenterStatus.operational),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCenters = _centers.where((center) {
      final matchesSearch =
          center.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          center.status.name.toLowerCase() == _selectedFilter.toLowerCase();
      return matchesSearch && matchesFilter;
    }).toList();

    return Container(
      height: 35.h,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Center Selection',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search centers...',
                      prefixIcon: Icon(Icons.search, size: 18.sp),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: AppTheme.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: AppTheme.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: AppTheme.primaryLight),
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 12.sp),
                  ),

                  SizedBox(height: 1.h),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'All',
                        'Operational',
                        'Maintenance',
                        'Critical'
                      ].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: EdgeInsets.only(right: 1.w),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            selectedColor:
                                AppTheme.primaryLight.withValues(alpha: 0.2),
                            checkmarkColor: AppTheme.primaryLight,
                            labelStyle: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primaryLight
                                  : AppTheme.textSecondaryLight,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Centers List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                itemCount: filteredCenters.length,
                itemBuilder: (context, index) {
                  final center = filteredCenters[index];
                  final isSelected = widget.selectedCenter == center.name;

                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: InkWell(
                      onTap: () => widget.onCenterSelected(center.name),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryLight.withValues(alpha: 0.1)
                              : AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : AppTheme.borderLight,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildStatusIndicator(center.status),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    center.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppTheme.primaryLight
                                          : AppTheme.onBackgroundLight,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: AppTheme.primaryLight,
                                    size: 16.sp,
                                  ),
                              ],
                            ),
                            if (center.id != 'all') ...[
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMetric(
                                      'Patients',
                                      center.activePatients.toString(),
                                      Icons.people,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildMetric(
                                      'Staff',
                                      center.staffCount.toString(),
                                      Icons.badge,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Quick Actions
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddCenterDialog(),
                      icon: Icon(Icons.add, size: 14.sp),
                      label: Text(
                        'Add Center',
                        style: GoogleFonts.inter(fontSize: 10.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showBulkActionsDialog(),
                      icon: Icon(Icons.settings, size: 14.sp),
                      label: Text(
                        'Bulk Actions',
                        style: GoogleFonts.inter(fontSize: 10.sp),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                      ),
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

  Widget _buildStatusIndicator(CenterStatus status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case CenterStatus.operational:
        statusColor = AppTheme.successLight;
        statusIcon = Icons.check_circle;
        break;
      case CenterStatus.maintenance:
        statusColor = AppTheme.warningLight;
        statusIcon = Icons.build_circle;
        break;
      case CenterStatus.critical:
        statusColor = AppTheme.errorLight;
        statusIcon = Icons.error;
        break;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Icon(
        statusIcon,
        color: statusColor,
        size: 12.sp,
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondaryLight,
          size: 10.sp,
        ),
        SizedBox(width: 1.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.onBackgroundLight,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddCenterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Center',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This feature allows you to add a new dialysis center to the network.',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement add center logic
            },
            child: Text('Add Center'),
          ),
        ],
      ),
    );
  }

  void _showBulkActionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Bulk Actions',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Refresh All Centers'),
              onTap: () {
                Navigator.pop(context);
                _refreshAllCenters();
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Broadcast Message'),
              onTap: () {
                Navigator.pop(context);
                _showBroadcastDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Schedule Maintenance'),
              onTap: () {
                Navigator.pop(context);
                _showMaintenanceDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _refreshAllCenters() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshing all center data...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showBroadcastDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Broadcast Message'),
        content: TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your message here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Maintenance'),
        content: Text('Select centers and schedule maintenance windows.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Schedule'),
          ),
        ],
      ),
    );
  }
}

class CenterInfo {
  final String name;
  final String id;
  final int activePatients;
  final int staffCount;
  final CenterStatus status;

  CenterInfo(
      this.name, this.id, this.activePatients, this.staffCount, this.status);
}

enum CenterStatus { operational, maintenance, critical }
