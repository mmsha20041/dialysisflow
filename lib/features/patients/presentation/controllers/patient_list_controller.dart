import 'package:dialysisflow/features/patients/domain/repositories/patient_repository.dart';

class PatientListController {
  PatientListController(this._repository);

  final PatientRepository _repository;

  Future<List<Map<String, dynamic>>> loadPatients() => _repository.getPatients();

  Future<List<Map<String, dynamic>>> loadFilters() =>
      _repository.getPatientFilters();
}
