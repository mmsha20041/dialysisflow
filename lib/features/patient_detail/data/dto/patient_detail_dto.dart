class PatientDetailDto {
  PatientDetailDto({
    required this.patientId,
    required this.history,
    required this.cycles,
    required this.documents,
    required this.vitals,
  });

  final String patientId;
  final List<Map<String, dynamic>> history;
  final List<Map<String, dynamic>> cycles;
  final List<Map<String, dynamic>> documents;
  final List<Map<String, dynamic>> vitals;

  factory PatientDetailDto.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> asList(String key) {
      return (json[key] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList();
    }

    return PatientDetailDto(
      patientId: json['patientId'] as String? ?? '',
      history: asList('history'),
      cycles: asList('cycles'),
      documents: asList('documents'),
      vitals: asList('vitals'),
    );
  }
}
