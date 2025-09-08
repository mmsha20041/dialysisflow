import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/healthcare_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/security_indicator_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _showBiometric = false;
  int _failedAttempts = 0;
  bool _isAccountLocked = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock credentials for different roles
  final Map<String, Map<String, String>> _mockCredentials = {
    'admin': {'password': 'admin123', 'role': 'Admin'},
    'doctor': {'password': 'doctor123', 'role': 'RMO'},
    'nurse': {'password': 'nurse123', 'role': 'Staff'},
    'arogya': {'password': 'arogya123', 'role': 'Arogya Mitra'},
  };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();

    // Show biometric option for returning users after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showBiometric = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(
      String username, String password, String selectedRole) async {
    if (_isAccountLocked) {
      _showErrorMessage(
          'Account is temporarily locked. Please try again later.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check credentials
      final credentials = _mockCredentials[username.toLowerCase()];
      if (credentials != null &&
          credentials['password'] == password &&
          credentials['role'] == selectedRole) {
        // Success - provide haptic feedback
        HapticFeedback.lightImpact();

        // Reset failed attempts
        setState(() {
          _failedAttempts = 0;
        });

        // Navigate to role-based dashboard
        Navigator.pushReplacementNamed(context, '/role-based-dashboard');
      } else {
        // Failed login
        HapticFeedback.heavyImpact();
        setState(() {
          _failedAttempts++;
          if (_failedAttempts >= 3) {
            _isAccountLocked = true;
            // Auto unlock after 30 seconds (for demo purposes)
            Future.delayed(const Duration(seconds: 30), () {
              if (mounted) {
                setState(() {
                  _isAccountLocked = false;
                  _failedAttempts = 0;
                });
              }
            });
          }
        });

        if (_failedAttempts >= 3) {
          _showErrorMessage(
              'Account locked due to multiple failed attempts. Please try again in 30 seconds.');
        } else {
          _showErrorMessage(
              'Invalid credentials. Please check your username, password, and selected role.');
        }
      }
    } catch (e) {
      _showErrorMessage(
          'Network error. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBiometricSuccess() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/role-based-dashboard');
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onError,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.w),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                  // Healthcare Logo
                  const HealthcareLogoWidget(),
                  SizedBox(height: 6.h),

                  // Security Indicator
                  Center(
                    child: SecurityIndicatorWidget(
                      isSecure: !_isAccountLocked && _failedAttempts == 0,
                      failedAttempts: _failedAttempts,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 4.h),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricSuccess: _handleBiometricSuccess,
                    isVisible:
                        _showBiometric && !_isLoading && !_isAccountLocked,
                  ),
                  SizedBox(height: 6.h),

                  // Footer Information
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

  Widget _buildFooter() {
    return Column(
      children: [
        // Version Info
        Text(
          'Version 1.0.0',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),

        // Compliance Info
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

        // Mock Credentials Info
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Demo Credentials',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'admin/admin123 (Admin) • doctor/doctor123 (RMO)\nnurse/nurse123 (Staff) • arogya/arogya123 (Arogya Mitra)',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
