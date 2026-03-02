import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/patient_registration.dart';
import '../dto/patient_registration_dto.dart';
import '../mappers/patient_registration_mapper.dart';

class PatientRegistrationRemoteDataSource {
  PatientRegistrationRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<SubmitRegistrationResponseDto> submitRegistration(
    PatientRegistration payload,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/patients/registration',
      data: payload.toJson(),
    );

    return SubmitRegistrationResponseDto.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }

  Future<UploadDocumentResponseDto> uploadDocument({
    required String patientId,
    required String filePath,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    final response = await _apiClient.post<Map<String, dynamic>>(
      '/patients/$patientId/documents',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return UploadDocumentResponseDto.fromJson(
      response.data ?? <String, dynamic>{},
    );
  }
}
