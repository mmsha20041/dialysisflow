import '../../domain/entities/session.dart';
import '../dto/session_dto.dart';

extension SessionDtoMapper on SessionDto {
  Session toDomain() {
    return Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      role: role,
      expiresAt: DateTime.tryParse(expiresAt) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
