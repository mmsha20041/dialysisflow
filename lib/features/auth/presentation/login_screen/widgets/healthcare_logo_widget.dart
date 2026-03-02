import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';

class HealthcareLogoWidget extends StatelessWidget {
  const HealthcareLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(6.w),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background medical cross pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: MedicalCrossPainter(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Main logo content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'local_hospital',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'DF',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),

        // App Name
        Text(
          'DialysisFlow',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Healthcare Management System',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MedicalCrossPainter extends CustomPainter {
  final Color color;

  MedicalCrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final crossSize = size.width * 0.3;

    // Vertical bar of cross
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: crossSize * 0.3,
        height: crossSize,
      ),
      paint,
    );

    // Horizontal bar of cross
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: crossSize,
        height: crossSize * 0.3,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
