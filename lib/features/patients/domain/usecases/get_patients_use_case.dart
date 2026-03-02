import 'package:dialysisflow/features/patients/domain/repositories/patient_repository.dart';

class GetPatientsUseCase {
  GetPatientsUseCase(this._repository);

  final PatientRepository _repository;

  Future<List<Map<String, dynamic>>> call() => _repository.getPatients();
}
