import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';

class MedicalHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> historyData;

  const MedicalHistoryWidget({
    Key? key,
    required this.historyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return historyData.isEmpty ? _buildEmptyState() : _buildHistoryList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Medical History Available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Medical history will appear here once treatments begin',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: historyData.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final history = historyData[index];
        return _buildHistoryCard(history);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> history) {
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
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      _getCycleStatusColor(history["status"] as String? ?? "")
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getCycleStatusColor(
                        history["status"] as String? ?? ""),
                    width: 1,
                  ),
                ),
                child: Text(
                  history["cycleType"] as String? ?? "Unknown Cycle",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getCycleStatusColor(
                        history["status"] as String? ?? ""),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(history["startDate"] as String? ?? ""),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            history["diagnosis"] as String? ?? "No diagnosis available",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Text(
            history["treatment"] as String? ?? "No treatment details available",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildInfoChip(
                icon: 'medical_services',
                label: 'Sessions',
                value:
                    '${history["completedSessions"] ?? 0}/${history["totalSessions"] ?? 0}',
              ),
              SizedBox(width: 3.w),
              _buildInfoChip(
                icon: 'schedule',
                label: 'Duration',
                value: history["duration"] as String? ?? "N/A",
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Dr. ${history["doctor"] as String? ?? "Unknown"}",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showHistoryDetails(history),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Details',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 4.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.primaryColor,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCycleStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.getStatusColor('success');
      case 'ongoing':
      case 'active':
        return AppTheme.getStatusColor('warning');
      case 'cancelled':
        return AppTheme.getStatusColor('error');
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  void _showHistoryDetails(Map<String, dynamic> history) {
    // This would typically show a detailed view or navigate to a details screen
    // For now, we'll just print the history data
    print('Showing details for: ${history["diagnosis"]}');
  }
}
