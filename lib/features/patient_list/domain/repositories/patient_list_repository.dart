import '../entities/paginated_patients.dart';
import '../entities/patient_filters.dart';

abstract class PatientListRepository {
  Future<PaginatedPatients> fetchPatients({
    required int page,
    required int pageSize,
    PatientFilters? filters,
  });
}
