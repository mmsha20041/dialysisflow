class Session {
  Session({
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
  final DateTime expiresAt;
}
