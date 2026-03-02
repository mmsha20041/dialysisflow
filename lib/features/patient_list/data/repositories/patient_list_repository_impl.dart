import '../../domain/entities/paginated_patients.dart';
import '../../domain/entities/patient_filters.dart';
import '../../domain/repositories/patient_list_repository.dart';
import '../datasources/patient_list_remote_datasource.dart';
import '../mappers/patient_list_mapper.dart';

class PatientListRepositoryImpl implements PatientListRepository {
  PatientListRepositoryImpl(this._remoteDataSource);

  final PatientListRemoteDataSource _remoteDataSource;

  @override
  Future<PaginatedPatients> fetchPatients({
    required int page,
    required int pageSize,
    PatientFilters? filters,
  }) async {
    final dto = await _remoteDataSource.fetchPatients(
      page: page,
      pageSize: pageSize,
      filters: filters,
    );

    return dto.toDomain();
  }
}
