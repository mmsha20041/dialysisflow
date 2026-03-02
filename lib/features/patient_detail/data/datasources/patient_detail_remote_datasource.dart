import '../../../../core/network/api_client.dart';
import '../dto/patient_detail_dto.dart';

class PatientDetailRemoteDataSource {
  PatientDetailRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<PatientDetailDto> fetchPatientDetail(String patientId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/patients/$patientId/detail',
    );

    return PatientDetailDto.fromJson(response.data ?? <String, dynamic>{});
  }
}
