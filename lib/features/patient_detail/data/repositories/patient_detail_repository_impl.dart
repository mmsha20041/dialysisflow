import '../../domain/entities/patient_detail.dart';
import '../../domain/repositories/patient_detail_repository.dart';
import '../datasources/patient_detail_remote_datasource.dart';
import '../mappers/patient_detail_mapper.dart';

class PatientDetailRepositoryImpl implements PatientDetailRepository {
  PatientDetailRepositoryImpl(this._remoteDataSource);

  final PatientDetailRemoteDataSource _remoteDataSource;

  @override
  Future<PatientDetail> fetchPatientDetail(String patientId) async {
    final dto = await _remoteDataSource.fetchPatientDetail(patientId);
    return dto.toDomain();
  }
}
