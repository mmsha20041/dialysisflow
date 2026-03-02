import '../../../../core/network/api_client.dart';
import '../../domain/entities/patient_filters.dart';
import '../dto/paginated_patient_list_dto.dart';

class PatientListRemoteDataSource {
  PatientListRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<PaginatedPatientListDto> fetchPatients({
    required int page,
    required int pageSize,
    PatientFilters? filters,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/patients',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        ...?filters?.toQueryParameters(),
      },
    );

    return PaginatedPatientListDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
