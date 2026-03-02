class SubmitRegistrationResponseDto {
  SubmitRegistrationResponseDto({
    required this.patientId,
    required this.createdAt,
  });

  final String patientId;
  final String createdAt;

  factory SubmitRegistrationResponseDto.fromJson(Map<String, dynamic> json) {
    return SubmitRegistrationResponseDto(
      patientId: json['patientId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class UploadDocumentResponseDto {
  UploadDocumentResponseDto({
    required this.documentId,
    required this.name,
    required this.url,
  });

  final String documentId;
  final String name;
  final String url;

  factory UploadDocumentResponseDto.fromJson(Map<String, dynamic> json) {
    return UploadDocumentResponseDto(
      documentId: json['documentId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}
