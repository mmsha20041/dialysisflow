import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class QuickActionFabWidget extends StatelessWidget {
  final String userRole;
  final VoidCallback onPressed;

  const QuickActionFabWidget({
    Key? key,
    required this.userRole,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      icon: CustomIconWidget(
        iconName: _getActionIcon(),
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 20,
      ),
      label: Text(
        _getActionLabel(),
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getActionIcon() {
    switch (userRole.toLowerCase()) {
      case 'staff':
      case 'nurse':
        return 'calendar_month';
      case 'rmo':
      case 'doctor':
        return 'assignment';
      case 'arogya mitra':
        return 'upload_file';
      case 'admin':
        return 'analytics';
      default:
        return 'add';
    }
  }

  String _getActionLabel() {
    switch (userRole.toLowerCase()) {
      case 'staff':
      case 'nurse':
        return 'Schedule Session';
      case 'rmo':
      case 'doctor':
        return 'Review Notes';
      case 'arogya mitra':
        return 'Submit Claims';
      case 'admin':
        return 'View Analytics';
      default:
        return 'Quick Action';
    }
  }
}
