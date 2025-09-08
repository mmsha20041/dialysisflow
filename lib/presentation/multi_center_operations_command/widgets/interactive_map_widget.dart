import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class InteractiveMapWidget extends StatefulWidget {
  final bool isExpanded;

  const InteractiveMapWidget({
    super.key,
    required this.isExpanded,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Operational',
    'Maintenance',
    'Critical'
  ];

  final List<CenterLocation> _centers = [
    CenterLocation('Downtown Center', 0.3, 0.4, CenterStatus.operational, 85),
    CenterLocation('Northside Clinic', 0.2, 0.2, CenterStatus.operational, 92),
    CenterLocation('Westside Branch', 0.1, 0.6, CenterStatus.maintenance, 0),
    CenterLocation('Eastside Facility', 0.7, 0.3, CenterStatus.operational, 78),
    CenterLocation('Southside Center', 0.5, 0.8, CenterStatus.critical, 45),
    CenterLocation('Midtown Unit', 0.6, 0.5, CenterStatus.operational, 95),
    CenterLocation('Riverside Clinic', 0.4, 0.7, CenterStatus.operational, 88),
    CenterLocation('Hillside Branch', 0.8, 0.1, CenterStatus.operational, 82),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCenters = _centers.where((center) {
      if (_selectedFilter == 'All') return true;
      return center.status.name.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();

    return Column(
      children: [
        // Map Filters
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Row(
            children: [
              Text(
                'Filter:',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: EdgeInsets.only(right: 2.w),
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
                            fontSize: 10.sp,
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
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Interactive Map Display
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Stack(
              children: [
                // Map Background
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade50,
                        Colors.green.shade50,
                      ],
                    ),
                  ),
                ),

                // Center Markers
                ...filteredCenters.map((center) => _buildCenterMarker(center)),

                // Legend
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Status',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onBackgroundLight,
                          ),
                        ),
                        SizedBox(height: 1.w),
                        _buildLegendItem(
                            CenterStatus.operational, 'Operational'),
                        _buildLegendItem(
                            CenterStatus.maintenance, 'Maintenance'),
                        _buildLegendItem(CenterStatus.critical, 'Critical'),
                      ],
                    ),
                  ),
                ),

                // Capacity Heat Map Indicator
                if (widget.isExpanded)
                  Positioned(
                    bottom: 2.w,
                    left: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Capacity Heat Map',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onBackgroundLight,
                            ),
                          ),
                          SizedBox(height: 1.w),
                          Row(
                            children: [
                              _buildHeatMapIndicator(Colors.green, '0-50%'),
                              SizedBox(width: 2.w),
                              _buildHeatMapIndicator(Colors.yellow, '51-80%'),
                              SizedBox(width: 2.w),
                              _buildHeatMapIndicator(Colors.red, '81-100%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterMarker(CenterLocation center) {
    final markerColor = _getStatusColor(center.status);
    final heatMapColor = _getCapacityHeatColor(center.capacityUtilization);

    return Positioned(
      left: center.x * 80.w,
      top: center.y * 25.h,
      child: GestureDetector(
        onTap: () => _showCenterDetails(center),
        child: Container(
          width: widget.isExpanded ? 6.w : 4.w,
          height: widget.isExpanded ? 6.w : 4.w,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: heatMapColor,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: markerColor.withValues(alpha: 0.3),
                blurRadius: 8.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _getStatusIcon(center.status),
              color: AppTheme.backgroundLight,
              size: widget.isExpanded ? 12.sp : 10.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(CenterStatus status, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMapIndicator(Color color, String range) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          range,
          style: GoogleFonts.inter(
            fontSize: 7.sp,
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(CenterStatus status) {
    switch (status) {
      case CenterStatus.operational:
        return AppTheme.successLight;
      case CenterStatus.maintenance:
        return AppTheme.warningLight;
      case CenterStatus.critical:
        return AppTheme.errorLight;
    }
  }

  Color _getCapacityHeatColor(int capacity) {
    if (capacity <= 50) return Colors.green;
    if (capacity <= 80) return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(CenterStatus status) {
    switch (status) {
      case CenterStatus.operational:
        return Icons.check;
      case CenterStatus.maintenance:
        return Icons.build;
      case CenterStatus.critical:
        return Icons.warning;
    }
  }

  void _showCenterDetails(CenterLocation center) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              center.name,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.onBackgroundLight,
              ),
            ),
            SizedBox(height: 2.h),
            _buildDetailRow('Status', center.status.name),
            _buildDetailRow('Capacity', '${center.capacityUtilization}%'),
            _buildDetailRow('Active Patients', '142'),
            _buildDetailRow('Staff On Duty', '24'),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to center details
                    },
                    child: Text('View Details'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Contact center
                    },
                    child: Text('Contact Center'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.onBackgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}

class CenterLocation {
  final String name;
  final double x;
  final double y;
  final CenterStatus status;
  final int capacityUtilization;

  CenterLocation(
      this.name, this.x, this.y, this.status, this.capacityUtilization);
}

enum CenterStatus { operational, maintenance, critical }
