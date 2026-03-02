import '../../domain/entities/patient_registration.dart';
import '../dto/patient_registration_dto.dart';

extension PatientRegistrationPayloadMapper on PatientRegistration {
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'governmentId': governmentId,
      'primaryDiagnosis': primaryDiagnosis,
      'centerId': centerId,
    };
  }
}

extension SubmitRegistrationResponseMapper on SubmitRegistrationResponseDto {
  PatientRegistrationResult toDomain() {
    return PatientRegistrationResult(
      patientId: patientId,
      createdAt:
          DateTime.tryParse(createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

extension UploadDocumentResponseMapper on UploadDocumentResponseDto {
  UploadedDocument toDomain() {
    return UploadedDocument(
      documentId: documentId,
      name: name,
      url: url,
    );
  }
}
