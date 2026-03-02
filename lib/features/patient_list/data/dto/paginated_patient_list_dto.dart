import 'patient_summary_dto.dart';

class PaginatedPatientListDto {
  PaginatedPatientListDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  final List<PatientSummaryDto> items;
  final int page;
  final int pageSize;
  final int totalCount;

  factory PaginatedPatientListDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList();

    return PaginatedPatientListDto(
      items: rawItems.map(PatientSummaryDto.fromJson).toList(),
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? rawItems.length,
      totalCount: json['totalCount'] as int? ?? rawItems.length,
    );
  }
}
