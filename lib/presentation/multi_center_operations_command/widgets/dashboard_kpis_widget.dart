import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';
import '../../../theme/app_theme.dart';

class DashboardKpisWidget extends StatefulWidget {
  final String selectedCenter;

  const DashboardKpisWidget({
    super.key,
    required this.selectedCenter,
  });

  @override
  State<DashboardKpisWidget> createState() => _DashboardKpisWidgetState();
}

class _DashboardKpisWidgetState extends State<DashboardKpisWidget> {
  String _selectedTimePeriod = 'Today';
  final List<String> _timePeriods = ['Today', 'Week', 'Month', 'Quarter'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Time Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key Performance Indicators',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackgroundLight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTimePeriod,
                    items: _timePeriods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(
                          period,
                          style: GoogleFonts.inter(fontSize: 12.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimePeriod = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Primary KPIs Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 2.h,
            crossAxisSpacing: 4.w,
            childAspectRatio: 1.2,
            children: [
              _buildKpiCard(
                title: 'Patient Transfers',
                value: '24',
                change: '+8.5%',
                isPositive: true,
                icon: Icons.swap_horiz,
                color: AppTheme.primaryLight,
              ),
              _buildKpiCard(
                title: 'Staff Utilization',
                value: '87%',
                change: '+2.3%',
                isPositive: true,
                icon: Icons.people,
                color: AppTheme.successLight,
              ),
              _buildKpiCard(
                title: 'Equipment Status',
                value: '94%',
                change: '-1.2%',
                isPositive: false,
                icon: Icons.medical_services,
                color: AppTheme.warningLight,
              ),
              _buildKpiCard(
                title: 'Compliance Score',
                value: '98.5%',
                change: '+0.8%',
                isPositive: true,
                icon: Icons.verified,
                color: AppTheme.successLight,
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Charts Section
          Row(
            children: [
              // Transfer Trends Chart
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transfer Trends',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onBackgroundLight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          height: 20.h,
                          child: LineChart(_buildTransferTrendsChart()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Capacity Distribution
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capacity Distribution',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onBackgroundLight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          height: 20.h,
                          child: PieChart(_buildCapacityDistributionChart()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Detailed Metrics Table
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detailed Center Metrics',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildMetricsTable(),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Action Items
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Action Items',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onBackgroundLight,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildActionItem(
                    'High Priority',
                    'Northside Clinic requires additional staff allocation',
                    AppTheme.errorLight,
                    Icons.priority_high,
                  ),
                  _buildActionItem(
                    'Medium Priority',
                    'Equipment maintenance scheduled for 3 centers',
                    AppTheme.warningLight,
                    Icons.build,
                  ),
                  _buildActionItem(
                    'Low Priority',
                    'Update compliance documentation for Q4',
                    AppTheme.successLight,
                    Icons.task_alt,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: (isPositive
                            ? AppTheme.successLight
                            : AppTheme.errorLight)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        size: 12.sp,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        change,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: isPositive
                              ? AppTheme.successLight
                              : AppTheme.errorLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.onBackgroundLight,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildTransferTrendsChart() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 3),
            const FlSpot(1, 4),
            const FlSpot(2, 2),
            const FlSpot(3, 5),
            const FlSpot(4, 3),
            const FlSpot(5, 6),
            const FlSpot(6, 4),
          ],
          isCurved: true,
          color: AppTheme.primaryLight,
          barWidth: 3,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.primaryLight.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  PieChartData _buildCapacityDistributionChart() {
    return PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: [
        PieChartSectionData(
          color: AppTheme.successLight,
          value: 45,
          title: '45%',
          radius: 60,
          titleStyle: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.backgroundLight,
          ),
        ),
        PieChartSectionData(
          color: AppTheme.warningLight,
          value: 35,
          title: '35%',
          radius: 60,
          titleStyle: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.backgroundLight,
          ),
        ),
        PieChartSectionData(
          color: AppTheme.errorLight,
          value: 20,
          title: '20%',
          radius: 60,
          titleStyle: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.backgroundLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsTable() {
    final centers = [
      {
        'name': 'Downtown Center',
        'patients': '180',
        'capacity': '85%',
        'compliance': '98%'
      },
      {
        'name': 'Northside Clinic',
        'patients': '145',
        'capacity': '92%',
        'compliance': '97%'
      },
      {
        'name': 'Eastside Facility',
        'patients': '167',
        'capacity': '78%',
        'compliance': '99%'
      },
      {
        'name': 'Midtown Unit',
        'patients': '203',
        'capacity': '95%',
        'compliance': '98%'
      },
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: AppTheme.surfaceLight),
          children: [
            _buildTableHeader('Center'),
            _buildTableHeader('Patients'),
            _buildTableHeader('Capacity'),
            _buildTableHeader('Compliance'),
          ],
        ),
        ...centers
            .map((center) => TableRow(
                  children: [
                    _buildTableCell(center['name']!),
                    _buildTableCell(center['patients']!),
                    _buildTableCell(center['capacity']!),
                    _buildTableCell(center['compliance']!),
                  ],
                ))
            .toList(),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.onBackgroundLight,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          color: AppTheme.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _buildActionItem(
      String priority, String description, Color color, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16.sp,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  priority,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
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
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle action
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
