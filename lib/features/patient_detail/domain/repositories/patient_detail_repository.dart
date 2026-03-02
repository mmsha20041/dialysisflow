import '../entities/patient_detail.dart';

abstract class PatientDetailRepository {
  Future<PatientDetail> fetchPatientDetail(String patientId);
}
