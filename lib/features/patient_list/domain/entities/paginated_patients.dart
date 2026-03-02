import 'patient.dart';

class PaginatedPatients {
  PaginatedPatients({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  final List<Patient> items;
  final int page;
  final int pageSize;
  final int totalCount;
}
