import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityIndicatorWidget extends StatelessWidget {
  final bool isSecure;
  final int failedAttempts;

  const SecurityIndicatorWidget({
    Key? key,
    required this.isSecure,
    required this.failedAttempts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getIconName(),
            color: _getIconColor(),
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              _getSecurityMessage(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (failedAttempts >= 3) {
      return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
    } else if (failedAttempts > 0) {
      return const Color(0xFFF59E0B).withValues(alpha: 0.1); // Warning color
    } else if (isSecure) {
      return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
    }
    return AppTheme.lightTheme.colorScheme.surface;
  }

  Color _getBorderColor() {
    if (failedAttempts >= 3) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (failedAttempts > 0) {
      return const Color(0xFFF59E0B); // Warning color
    } else if (isSecure) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
    return AppTheme.lightTheme.colorScheme.outline;
  }

  Color _getIconColor() {
    if (failedAttempts >= 3) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (failedAttempts > 0) {
      return const Color(0xFFF59E0B); // Warning color
    } else if (isSecure) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  Color _getTextColor() {
    if (failedAttempts >= 3) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (failedAttempts > 0) {
      return const Color(0xFFF59E0B); // Warning color
    } else if (isSecure) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  String _getIconName() {
    if (failedAttempts >= 3) {
      return 'lock';
    } else if (failedAttempts > 0) {
      return 'warning';
    } else if (isSecure) {
      return 'verified_user';
    }
    return 'security';
  }

  String _getSecurityMessage() {
    if (failedAttempts >= 3) {
      return 'Account temporarily locked';
    } else if (failedAttempts == 2) {
      return 'Warning: 1 attempt remaining';
    } else if (failedAttempts == 1) {
      return 'Warning: 2 attempts remaining';
    } else if (isSecure) {
      return 'HIPAA Compliant • Medical Grade Security';
    }
    return 'Secure Healthcare Login';
  }
}
