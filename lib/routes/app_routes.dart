import 'package:flutter/material.dart';
import '../presentation/patient_detail/patient_detail.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/role_based_dashboard/role_based_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/patient_list/patient_list.dart';
import '../presentation/patient_registration/patient_registration.dart';
import '../presentation/multi_center_operations_command/multi_center_operations_command.dart';

class AppRoutes {
  // TODO: Add your routes here
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
    // TODO: Add your other routes here
  };
}
