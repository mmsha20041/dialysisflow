import 'package:dialysisflow/features/patients/domain/repositories/patient_repository.dart';

class GetPatientDetailUseCase {
  GetPatientDetailUseCase(this._repository);

  final PatientRepository _repository;

  Future<Map<String, dynamic>> call(String patientId) =>
      _repository.getPatientDetail(patientId);
}
