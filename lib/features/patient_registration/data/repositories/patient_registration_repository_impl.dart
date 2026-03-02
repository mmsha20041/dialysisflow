import '../../domain/entities/patient_registration.dart';
import '../../domain/repositories/patient_registration_repository.dart';
import '../datasources/patient_registration_remote_datasource.dart';
import '../mappers/patient_registration_mapper.dart';

class PatientRegistrationRepositoryImpl implements PatientRegistrationRepository {
  PatientRegistrationRepositoryImpl(this._remoteDataSource);

  final PatientRegistrationRemoteDataSource _remoteDataSource;

  @override
  Future<PatientRegistrationResult> submitRegistration(
    PatientRegistration payload,
  ) async {
    final dto = await _remoteDataSource.submitRegistration(payload);
    return dto.toDomain();
  }

  @override
  Future<UploadedDocument> uploadDocument({
    required String patientId,
    required String filePath,
    required String fileName,
  }) async {
    final dto = await _remoteDataSource.uploadDocument(
      patientId: patientId,
      filePath: filePath,
      fileName: fileName,
    );

    return dto.toDomain();
  }
}
