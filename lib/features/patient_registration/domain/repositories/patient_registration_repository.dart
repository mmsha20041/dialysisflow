import '../entities/patient_registration.dart';

abstract class PatientRegistrationRepository {
  Future<PatientRegistrationResult> submitRegistration(
    PatientRegistration payload,
  );

  Future<UploadedDocument> uploadDocument({
    required String patientId,
    required String filePath,
    required String fileName,
  });
}
