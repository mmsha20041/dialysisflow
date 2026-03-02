class SessionDto {
  SessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;
  final String expiresAt;

  factory SessionDto.fromJson(Map<String, dynamic> json) {
    return SessionDto(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      role: json['role'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
    );
  }
}
