import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatientCardWidget extends StatelessWidget {
  final Map<String, dynamic> patient;
  final VoidCallback? onTap;
  final VoidCallback? onStartSession;
  final VoidCallback? onViewRecords;
  final VoidCallback? onCallPatient;
  final VoidCallback? onEditDetails;
  final VoidCallback? onTransferCenter;
  final VoidCallback? onArchive;
  final bool isSelected;
  final VoidCallback? onLongPress;

  const PatientCardWidget({
    Key? key,
    required this.patient,
    this.onTap,
    this.onStartSession,
    this.onViewRecords,
    this.onCallPatient,
    this.onEditDetails,
    this.onTransferCenter,
    this.onArchive,
    this.isSelected = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(patient['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onStartSession?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.play_arrow,
              label: 'Start Session',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onViewRecords?.call(),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.folder_open,
              label: 'Records',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onCallPatient?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.phone,
              label: 'Call',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEditDetails?.call(),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onTransferCenter?.call(),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              icon: Icons.transfer_within_a_station,
              label: 'Transfer',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onArchive?.call(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: AppTheme.lightTheme.primaryColor, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Hero(
                  tag: 'patient_avatar_${patient['id']}',
                  child: CircleAvatar(
                    radius: 6.w,
                    backgroundColor:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    child: patient['avatar'] != null
                        ? CustomImageWidget(
                            imageUrl: patient['avatar'],
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          )
                        : CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 6.w,
                          ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              patient['name'] ?? 'Unknown Patient',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSelected)
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 5.w,
                            ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'UHID: ${patient['uhid'] ?? 'N/A'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getStatusColor(patient['status'])
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              patient['status'] ?? 'Unknown',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getStatusColor(patient['status']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            patient['lastSession'] ?? 'No sessions',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
      case 'in session':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending approval':
      case 'scheduled':
        return Colors.orange;
      case 'discharged':
      case 'completed':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'cancelled':
      case 'archived':
        return Colors.red;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
