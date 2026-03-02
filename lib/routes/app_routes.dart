import 'package:flutter/material.dart';
import 'package:dialysisflow/features/auth/presentation/login_screen/login_screen.dart';
import 'package:dialysisflow/features/dashboard/presentation/role_based_dashboard/role_based_dashboard.dart';
import 'package:dialysisflow/features/patients/presentation/patient_detail/patient_detail.dart';
import 'package:dialysisflow/features/patients/presentation/patient_list/patient_list.dart';

import '../presentation/multi_center_operations_command/multi_center_operations_command.dart';
import '../presentation/patient_registration/patient_registration.dart';
import '../presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String patientDetail = '/patient-detail';
  static const String splash = '/splash-screen';
  static const String roleBasedDashboard = '/role-based-dashboard';
  static const String login = '/login-screen';
  static const String patientList = '/patient-list';
  static const String patientRegistration = '/patient-registration';
  static const String multiCenterOperationsCommand =
      '/multi-center-operations-command';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    patientDetail: (context) => const PatientDetail(),
    splash: (context) => const SplashScreen(),
    roleBasedDashboard: (context) => const RoleBasedDashboard(),
    login: (context) => const LoginScreen(),
    patientList: (context) => const PatientList(),
    patientRegistration: (context) => const PatientRegistration(),
    multiCenterOperationsCommand: (context) =>
        const MultiCenterOperationsCommand(),
  };
}
