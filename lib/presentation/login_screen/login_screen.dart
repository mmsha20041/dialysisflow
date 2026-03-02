import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/services/auth_service.dart';
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
  final AuthService _authService = AuthService();

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
      final response = await _authService.signIn(
        email: username.contains('@') ? username : '$username@dialysisflow.com',
        password: password,
      );

      if (response.user != null) {
        HapticFeedback.lightImpact();

        setState(() {
          _failedAttempts = 0;
        });

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/role-based-dashboard');
        }
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _failedAttempts++;
        if (_failedAttempts >= 3) {
          _isAccountLocked = true;
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
            'Invalid credentials. Please check your email and password.');
      }
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.12),
              AppTheme.lightTheme.scaffoldBackgroundColor,
              AppTheme.lightTheme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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
                    SizedBox(height: 4.h),
                    const HealthcareLogoWidget(),
                    SizedBox(height: 3.h),
                    Center(
                      child: SecurityIndicatorWidget(
                        isSecure: !_isAccountLocked && _failedAttempts == 0,
                        failedAttempts: _failedAttempts,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.08),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          LoginFormWidget(
                            onLogin: _handleLogin,
                            isLoading: _isLoading,
                          ),
                          SizedBox(height: 2.h),
                          BiometricAuthWidget(
                            onBiometricSuccess: _handleBiometricSuccess,
                            isVisible: _showBiometric &&
                                !_isLoading &&
                                !_isAccountLocked,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    _buildFooter(),
                    SizedBox(height: 2.h),
                  ],
                ),
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
