import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VitalsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> vitalsData;

  const VitalsWidget({
    Key? key,
    required this.vitalsData,
  }) : super(key: key);

  @override
  State<VitalsWidget> createState() => _VitalsWidgetState();
}

class _VitalsWidgetState extends State<VitalsWidget> {
  String selectedVital = 'Blood Pressure';
  String selectedRange = '7 Days';

  final List<String> vitalTypes = [
    'Blood Pressure',
    'Heart Rate',
    'Temperature',
    'Weight',
    'Fluid Removal'
  ];

  final List<String> dateRanges = ['7 Days', '1 Month', '3 Months', '6 Months'];

  @override
  Widget build(BuildContext context) {
    return widget.vitalsData.isEmpty
        ? _buildEmptyState()
        : _buildVitalsContent();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'monitor_heart',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Vitals Data Available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Vitals will be recorded during dialysis sessions',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsContent() {
    return Column(
      children: [
        _buildVitalSelector(),
        SizedBox(height: 2.h),
        _buildDateRangeSelector(),
        SizedBox(height: 3.h),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                _buildCurrentVitalsCard(),
                SizedBox(height: 3.h),
                _buildVitalsChart(),
                SizedBox(height: 3.h),
                _buildVitalsHistory(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSelector() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: vitalTypes.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final vital = vitalTypes[index];
          final isSelected = selectedVital == vital;

          return GestureDetector(
            onTap: () => setState(() => selectedVital = vital),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  vital,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: dateRanges.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final range = dateRanges[index];
          final isSelected = selectedRange == range;

          return GestureDetector(
            onTap: () => setState(() => selectedRange = range),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  range,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentVitalsCard() {
    final currentVitals = _getCurrentVitals();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current $selectedVital',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getVitalStatusColor(
                          currentVitals["status"] as String? ?? "normal")
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentVitals["status"] as String? ?? "Normal",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getVitalStatusColor(
                        currentVitals["status"] as String? ?? "normal"),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentVitals["value"] as String? ?? "N/A",
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      currentVitals["unit"] as String? ?? "",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Last Updated',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _formatDateTime(
                        currentVitals["timestamp"] as String? ?? ""),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildVitalRange(
                'Normal Range',
                currentVitals["normalRange"] as String? ?? "N/A",
                AppTheme.getStatusColor('success'),
              ),
              SizedBox(width: 4.w),
              _buildVitalRange(
                'Trend',
                currentVitals["trend"] as String? ?? "Stable",
                _getTrendColor(currentVitals["trend"] as String? ?? "stable"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalRange(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsChart() {
    final chartData = _getChartData();

    return Container(
      height: 30.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$selectedVital Trend',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child:
                              Text(_getDateLabel(value.toInt()), style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 42,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        );
                        return Text(value.toInt().toString(), style: style);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                minX: 0,
                maxX: chartData.length.toDouble() - 1,
                minY: 0,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.primaryColor,
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.lightTheme.primaryColor,
                          strokeWidth: 2,
                          strokeColor: AppTheme.lightTheme.colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.3),
                          AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsHistory() {
    final historyData = _getVitalsHistory();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Recent Readings',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historyData.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final reading = historyData[index];
              return ListTile(
                leading: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getVitalStatusColor(
                            reading["status"] as String? ?? "normal")
                        .withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getVitalIcon(selectedVital),
                      color: _getVitalStatusColor(
                          reading["status"] as String? ?? "normal"),
                      size: 5.w,
                    ),
                  ),
                ),
                title: Text(
                  '${reading["value"]} ${reading["unit"] ?? ""}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  _formatDateTime(reading["timestamp"] as String? ?? ""),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getVitalStatusColor(
                            reading["status"] as String? ?? "normal")
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reading["status"] as String? ?? "Normal",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getVitalStatusColor(
                          reading["status"] as String? ?? "normal"),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getCurrentVitals() {
    // Mock current vitals data based on selected vital type
    switch (selectedVital) {
      case 'Blood Pressure':
        return {
          "value": "120/80",
          "unit": "mmHg",
          "status": "normal",
          "timestamp":
              DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          "normalRange": "90-120/60-80",
          "trend": "stable"
        };
      case 'Heart Rate':
        return {
          "value": "72",
          "unit": "bpm",
          "status": "normal",
          "timestamp":
              DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          "normalRange": "60-100",
          "trend": "improving"
        };
      case 'Temperature':
        return {
          "value": "98.6",
          "unit": "°F",
          "status": "normal",
          "timestamp":
              DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          "normalRange": "97-99",
          "trend": "stable"
        };
      case 'Weight':
        return {
          "value": "70.5",
          "unit": "kg",
          "status": "normal",
          "timestamp":
              DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          "normalRange": "65-75",
          "trend": "decreasing"
        };
      case 'Fluid Removal':
        return {
          "value": "2.5",
          "unit": "L",
          "status": "normal",
          "timestamp":
              DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
          "normalRange": "1-3",
          "trend": "stable"
        };
      default:
        return {};
    }
  }

  List<FlSpot> _getChartData() {
    // Mock chart data based on selected vital and range
    List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      double value = 80 + (i * 5) + (i % 2 == 0 ? 10 : -5);
      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

  List<Map<String, dynamic>> _getVitalsHistory() {
    // Mock history data
    return [
      {
        "value": "118/78",
        "unit": "mmHg",
        "status": "normal",
        "timestamp":
            DateTime.now().subtract(Duration(hours: 4)).toIso8601String(),
      },
      {
        "value": "122/82",
        "unit": "mmHg",
        "status": "normal",
        "timestamp":
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      },
      {
        "value": "125/85",
        "unit": "mmHg",
        "status": "high",
        "timestamp":
            DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
      },
    ];
  }

  Color _getVitalStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return AppTheme.getStatusColor('success');
      case 'high':
      case 'low':
        return AppTheme.getStatusColor('warning');
      case 'critical':
        return AppTheme.getStatusColor('error');
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'improving':
        return AppTheme.getStatusColor('success');
      case 'stable':
        return AppTheme.lightTheme.primaryColor;
      case 'declining':
      case 'decreasing':
        return AppTheme.getStatusColor('warning');
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getVitalIcon(String vital) {
    switch (vital) {
      case 'Blood Pressure':
        return 'favorite';
      case 'Heart Rate':
        return 'monitor_heart';
      case 'Temperature':
        return 'thermostat';
      case 'Weight':
        return 'scale';
      case 'Fluid Removal':
        return 'water_drop';
      default:
        return 'health_and_safety';
    }
  }

  String _getDateLabel(int index) {
    final date = DateTime.now().subtract(Duration(days: 6 - index));
    return "${date.day}/${date.month}";
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return "${difference.inDays}d ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}h ago";
      } else {
        return "${difference.inMinutes}m ago";
      }
    } catch (e) {
      return dateString;
    }
  }
}
