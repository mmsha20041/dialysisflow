abstract class PatientRepository {
  Future<List<Map<String, dynamic>>> getPatients();
  Future<List<Map<String, dynamic>>> getPatientFilters();
  Future<Map<String, dynamic>> getPatientDetail(String patientId);
}
