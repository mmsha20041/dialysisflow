import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';

class DashboardCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;
  final String priority;
  final String iconName;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const DashboardCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.priority,
    required this.iconName,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPriorityColor().withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getPriorityColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: _getPriorityColor(),
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      count,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: _getPriorityColor(),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        priority,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getPriorityColor(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: _getProgressValue(),
                    backgroundColor: _getPriorityColor().withValues(alpha: 0.1),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(_getPriorityColor()),
                    minHeight: 4,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${(_getProgressValue() * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (priority.toLowerCase()) {
      case 'urgent':
      case 'high':
        return AppTheme.getStatusColor('error');
      case 'pending':
      case 'medium':
        return AppTheme.getStatusColor('warning');
      case 'completed':
      case 'low':
        return AppTheme.getStatusColor('success');
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  double _getProgressValue() {
    final countValue = int.tryParse(count) ?? 0;
    if (countValue == 0) return 0.0;

    switch (priority.toLowerCase()) {
      case 'urgent':
        return 0.9;
      case 'pending':
        return 0.6;
      case 'completed':
        return 1.0;
      default:
        return 0.3;
    }
  }
}
