import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/center_selection_widget.dart';
import './widgets/command_header_widget.dart';
import './widgets/dashboard_kpis_widget.dart';
import './widgets/interactive_map_widget.dart';
import './widgets/resource_management_widget.dart';

class MultiCenterOperationsCommand extends StatefulWidget {
  const MultiCenterOperationsCommand({super.key});

  @override
  State<MultiCenterOperationsCommand> createState() =>
      _MultiCenterOperationsCommandState();
}

class _MultiCenterOperationsCommandState
    extends State<MultiCenterOperationsCommand>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCenter = 'All Centers';
  bool _isMapExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: Text(
          'Multi-Center Operations Command',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.onBackgroundLight,
          ),
        ),
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTheme.primaryLight,
              size: 24.sp,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: AppTheme.onBackgroundLight,
              size: 24.sp,
            ),
            onPressed: () {
              // Handle settings
            },
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Command Header with Network Overview
            CommandHeaderWidget(),

            SizedBox(height: 2.h),

            // Interactive Map and Center Selection Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Interactive Map
                  Expanded(
                    flex: _isMapExpanded ? 3 : 2,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        height: 35.h,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Centers Map',
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.onBackgroundLight,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isMapExpanded
                                          ? Icons.compress
                                          : Icons.expand,
                                      color: AppTheme.primaryLight,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isMapExpanded = !_isMapExpanded;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: InteractiveMapWidget(
                                isExpanded: _isMapExpanded,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Center Selection Panel
                  Expanded(
                    flex: 1,
                    child: CenterSelectionWidget(
                      selectedCenter: _selectedCenter,
                      onCenterSelected: (center) {
                        setState(() {
                          _selectedCenter = center;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Main Dashboard with Tabbed Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: AppTheme.primaryLight,
                        indicatorWeight: 3.0,
                        labelColor: AppTheme.primaryLight,
                        unselectedLabelColor: AppTheme.textSecondaryLight,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        tabs: const [
                          Tab(text: 'KPIs'),
                          Tab(text: 'Resources'),
                          Tab(text: 'Patient Flow'),
                          Tab(text: 'Inventory'),
                          Tab(text: 'Compliance'),
                          Tab(text: 'Communications'),
                        ],
                      ),
                    ),

                    // Tab Content
                    Container(
                      height: 60.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          DashboardKpisWidget(selectedCenter: _selectedCenter),
                          ResourceManagementWidget(
                              selectedCenter: _selectedCenter),
                          // Replace missing widgets with placeholder containers
                          Container(
                            child: Center(
                              child: Text(
                                'Patient Flow Widget - Under Development',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                'Inventory Management Widget - Under Development',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                'Compliance Monitoring Widget - Under Development',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                'Communication Hub Widget - Under Development',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Performance Comparison Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Center(
                      child: Text(
                        'Performance Comparison Widget - Under Development',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showEmergencyActionDialog();
        },
        backgroundColor: AppTheme.errorLight,
        foregroundColor: AppTheme.onErrorLight,
        icon: const Icon(Icons.emergency),
        label: Text(
          'Emergency',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showEmergencyActionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Emergency Response',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.errorLight,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select emergency action:',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.onBackgroundLight,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: Icon(Icons.warning, color: AppTheme.warningLight),
              title: Text('System-wide Alert'),
              onTap: () {
                Navigator.pop(context);
                _broadcastAlert('System-wide Alert');
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hospital, color: AppTheme.errorLight),
              title: Text('Medical Emergency'),
              onTap: () {
                Navigator.pop(context);
                _broadcastAlert('Medical Emergency');
              },
            ),
            ListTile(
              leading: Icon(Icons.power_off, color: AppTheme.secondaryLight),
              title: Text('Power Outage Protocol'),
              onTap: () {
                Navigator.pop(context);
                _broadcastAlert('Power Outage Protocol');
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

  void _broadcastAlert(String alertType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$alertType broadcasted to all centers'),
        backgroundColor: AppTheme.errorLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}