class PatientSummaryDto {
  PatientSummaryDto({
    required this.id,
    required this.fullName,
    required this.mrn,
    required this.center,
    required this.status,
    this.nextSessionAt,
  });

  final String id;
  final String fullName;
  final String mrn;
  final String center;
  final String status;
  final String? nextSessionAt;

  factory PatientSummaryDto.fromJson(Map<String, dynamic> json) {
    return PatientSummaryDto(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      mrn: json['mrn'] as String? ?? '',
      center: json['center'] as String? ?? '',
      status: json['status'] as String? ?? '',
      nextSessionAt: json['nextSessionAt'] as String?,
    );
  }
}
