class PatientRegistration {
  PatientRegistration({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
    required this.governmentId,
    required this.primaryDiagnosis,
    required this.centerId,
  });

  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String phone;
  final String governmentId;
  final String primaryDiagnosis;
  final String centerId;
}

class PatientRegistrationResult {
  PatientRegistrationResult({
    required this.patientId,
    required this.createdAt,
  });

  final String patientId;
  final DateTime createdAt;
}

class UploadedDocument {
  UploadedDocument({
    required this.documentId,
    required this.name,
    required this.url,
  });

  final String documentId;
  final String name;
  final String url;
}
