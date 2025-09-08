import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CurrentCycleWidget extends StatelessWidget {
  final Map<String, dynamic>? currentCycle;

  const CurrentCycleWidget({
    Key? key,
    this.currentCycle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentCycle == null ? _buildNoCycleState() : _buildCycleDetails();
  }

  Widget _buildNoCycleState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'add_circle_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Active Cycle',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start a new dialysis cycle to begin treatment',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: () => _startNewCycle(),
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text('Start New Cycle'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleDetails() {
    final sessions =
        (currentCycle!["sessions"] as List).cast<Map<String, dynamic>>();
    final completedSessions =
        sessions.where((s) => s["status"] == "completed").length;
    final totalSessions = sessions.length;
    final progress =
        totalSessions > 0 ? completedSessions / totalSessions : 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCycleHeader(),
          SizedBox(height: 3.h),
          _buildProgressSection(completedSessions, totalSessions, progress),
          SizedBox(height: 3.h),
          _buildSessionsList(sessions),
        ],
      ),
    );
  }

  Widget _buildCycleHeader() {
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
              Expanded(
                child: Text(
                  currentCycle!["cycleType"] as String? ?? "Dialysis Cycle",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getCycleStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getCycleStatusColor(),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getCycleStatusText(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getCycleStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildInfoItem(
                icon: 'calendar_today',
                label: 'Start Date',
                value: _formatDate(currentCycle!["startDate"] as String? ?? ""),
              ),
              SizedBox(width: 4.w),
              _buildInfoItem(
                icon: 'assignment',
                label: 'TMS ID',
                value: currentCycle!["tmsId"] as String? ?? "N/A",
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            currentCycle!["diagnosis"] as String? ?? "No diagnosis available",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(int completed, int total, double progress) {
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
                'Session Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$completed/$total Sessions',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
            minHeight: 8,
          ),
          SizedBox(height: 2.h),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(List<Map<String, dynamic>> sessions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sessions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final session = sessions[index];
            return _buildSessionCard(session, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session, int sessionNumber) {
    final status = session["status"] as String? ?? "scheduled";
    final isCompleted = status == "completed";
    final isCurrent = status == "in_progress";
    final isScheduled = status == "scheduled";

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getSessionStatusColor(status).withValues(alpha: 0.1),
              border: Border.all(
                color: _getSessionStatusColor(status),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: _getSessionStatusColor(status),
                      size: 5.w,
                    )
                  : Text(
                      sessionNumber.toString(),
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: _getSessionStatusColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session $sessionNumber',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  session["scheduledDate"] as String? ?? "Not scheduled",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (session["duration"] != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Duration: ${session["duration"]}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getSessionStatusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getSessionStatusText(status),
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: _getSessionStatusColor(status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.primaryColor,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCycleStatusColor() {
    final status = currentCycle!["status"] as String? ?? "active";
    return AppTheme.getStatusColor(status);
  }

  String _getCycleStatusText() {
    final status = currentCycle!["status"] as String? ?? "active";
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending Approval';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getSessionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.getStatusColor('success');
      case 'in_progress':
        return AppTheme.getStatusColor('warning');
      case 'scheduled':
        return AppTheme.lightTheme.primaryColor;
      case 'cancelled':
        return AppTheme.getStatusColor('error');
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getSessionStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In Progress';
      case 'scheduled':
        return 'Scheduled';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
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

  void _startNewCycle() {
    // This would typically navigate to a new cycle creation screen
    print('Starting new cycle...');
  }
}
