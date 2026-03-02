import '../../domain/entities/paginated_patients.dart';
import '../../domain/entities/patient.dart';
import '../dto/paginated_patient_list_dto.dart';
import '../dto/patient_summary_dto.dart';

extension PatientSummaryDtoMapper on PatientSummaryDto {
  Patient toDomain() {
    return Patient(
      id: id,
      fullName: fullName,
      mrn: mrn,
      center: center,
      status: status,
      nextSessionAt: nextSessionAt != null ? DateTime.tryParse(nextSessionAt!) : null,
    );
  }
}

extension PaginatedPatientListDtoMapper on PaginatedPatientListDto {
  PaginatedPatients toDomain() {
    return PaginatedPatients(
      items: items.map((e) => e.toDomain()).toList(),
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
    );
  }
}
