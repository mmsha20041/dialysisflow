import '../../../../core/network/api_client.dart';
import '../dto/session_dto.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<SessionDto> createSession({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/session',
      data: {
        'email': email,
        'password': password,
      },
    );

    return SessionDto.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<void> revokeSession() async {
    await _apiClient.post<void>('/auth/session/revoke');
  }
}
