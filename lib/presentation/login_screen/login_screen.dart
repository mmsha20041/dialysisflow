import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './state/login_controller.dart';
import './state/login_state.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/healthcare_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/security_indicator_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next is LoginError) {
        HapticFeedback.heavyImpact();
        _showMessage(next.message, isError: true);
      }

      if (next is LoginSuccess && next.message != null) {
        HapticFeedback.lightImpact();
        if (next.message == 'Login successful' ||
            next.message == 'Biometric authentication successful') {
          Navigator.pushReplacementNamed(context, '/role-based-dashboard');
        }
      }
    });

    final state = ref.watch(loginControllerProvider);
    final isLoading = state is LoginLoading;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),
                  const HealthcareLogoWidget(),
                  SizedBox(height: 6.h),
                  Center(
                    child: SecurityIndicatorWidget(
                      isSecure: !state.data.isAccountLocked &&
                          state.data.failedAttempts == 0,
                      failedAttempts: state.data.failedAttempts,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  LoginFormWidget(
                    onLogin: (username, password, selectedRole) {
                      ref.read(loginControllerProvider.notifier).login(
                            username: username,
                            password: password,
                          );
                    },
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 4.h),
                  BiometricAuthWidget(
                    onBiometricSuccess: () {
                      ref
                          .read(loginControllerProvider.notifier)
                          .completeBiometricLogin();
                    },
                    isVisible: state.data.showBiometric &&
                        !isLoading &&
                        !state.data.isAccountLocked,
                  ),
                  SizedBox(height: 6.h),
                  _buildFooter(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isError
                ? AppTheme.lightTheme.colorScheme.onError
                : AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: isError
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Version 1.0.0',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'verified_user',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'HIPAA Compliant',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          'Secure Healthcare Access',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
