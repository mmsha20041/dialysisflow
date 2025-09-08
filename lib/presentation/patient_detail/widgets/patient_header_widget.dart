import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatientHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEdit;

  const PatientHeaderWidget({
    Key? key,
    required this.patientData,
    required this.onCall,
    required this.onMessage,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: patientData["avatar"] as String? ?? "",
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientData["name"] as String? ?? "Unknown Patient",
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "UHID: ${patientData["uhid"] as String? ?? "N/A"}",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "Age: ${patientData["age"] as int? ?? 0} | ${patientData["gender"] as String? ?? "N/A"}",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onCall,
                    icon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      shape: const CircleBorder(),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: onMessage,
                    icon: CustomIconWidget(
                      iconName: 'message',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      shape: const CircleBorder(),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: onEdit,
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getStatusColor(
                      patientData["currentStatus"] as String? ?? "inactive")
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStatusColor(
                    patientData["currentStatus"] as String? ?? "inactive"),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(
                        patientData["currentStatus"] as String? ?? "inactive"),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Status",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _getStatusText(
                            patientData["currentStatus"] as String? ??
                                "inactive"),
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: _getStatusColor(
                              patientData["currentStatus"] as String? ??
                                  "inactive"),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                patientData["tmsId"] != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "TMS ID",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            patientData["tmsId"] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'in_session':
        return AppTheme.getStatusColor('success');
      case 'scheduled':
      case 'pending':
        return AppTheme.getStatusColor('warning');
      case 'completed':
        return AppTheme.lightTheme.primaryColor;
      case 'cancelled':
      case 'inactive':
        return AppTheme.getStatusColor('error');
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active Treatment';
      case 'in_session':
        return 'In Session';
      case 'scheduled':
        return 'Scheduled';
      case 'pending':
        return 'Pending Approval';
      case 'completed':
        return 'Treatment Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'inactive':
        return 'Inactive';
      default:
        return 'Unknown Status';
    }
  }
}
