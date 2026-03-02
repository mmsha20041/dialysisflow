import 'package:dialysisflow/features/auth/data/datasources/mock_auth_data_source.dart';
import 'package:dialysisflow/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:dialysisflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:dialysisflow/features/dashboard/data/datasources/mock_dashboard_data_source.dart';
import 'package:dialysisflow/features/dashboard/data/repositories/mock_dashboard_repository.dart';
import 'package:dialysisflow/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dialysisflow/features/patients/data/datasources/mock_patient_detail_data_source.dart';
import 'package:dialysisflow/features/patients/data/datasources/mock_patient_list_data_source.dart';
import 'package:dialysisflow/features/patients/data/repositories/mock_patient_repository.dart';
import 'package:dialysisflow/features/patients/domain/repositories/patient_repository.dart';

class ServiceLocator {
  static final AuthRepository authRepository =
      MockAuthRepository(MockAuthDataSource());

  static final PatientRepository patientRepository = MockPatientRepository(
    listDataSource: MockPatientListDataSource(),
    detailDataSource: MockPatientDetailDataSource(),
  );

  static final DashboardRepository dashboardRepository =
      MockDashboardRepository(MockDashboardDataSource());
}
