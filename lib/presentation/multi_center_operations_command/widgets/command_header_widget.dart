import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CommandHeaderWidget extends StatelessWidget {
  const CommandHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryLight,
            AppTheme.primaryVariantLight,
          ],
        ),
      ),
      child: Column(
        children: [
          // Network Overview Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Network Overview',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onPrimaryLight,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.successLight,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: AppTheme.onPrimaryLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'All Systems Operational',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Network Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.business,
                  title: 'Total Centers',
                  value: '24',
                  subtitle: '22 Active, 2 Maintenance',
                  color: AppTheme.onPrimaryLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  title: 'Active Patients',
                  value: '3,847',
                  subtitle: '127 In Session',
                  color: AppTheme.onPrimaryLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.warning,
                  title: 'System Alerts',
                  value: '5',
                  subtitle: '2 Critical, 3 Info',
                  color: AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.trending_up,
                  title: 'Capacity',
                  value: '78%',
                  subtitle: 'Network Wide',
                  color: AppTheme.successLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Real-time Alerts Bar
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: AppTheme.onPrimaryLight.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.onPrimaryLight,
                  size: 16.sp,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Latest: Equipment maintenance scheduled for Downtown Center at 15:00',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppTheme.onPrimaryLight,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show all alerts
                  },
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.onPrimaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.onPrimaryLight.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
              if (title == 'System Alerts' && value != '0')
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onErrorLight,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.9),
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              color: AppTheme.onPrimaryLight.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
