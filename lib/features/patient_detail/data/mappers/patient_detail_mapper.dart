import '../../domain/entities/patient_detail.dart';
import '../dto/patient_detail_dto.dart';

extension PatientDetailDtoMapper on PatientDetailDto {
  PatientDetail toDomain() {
    return PatientDetail(
      patientId: patientId,
      history: history
          .map(
            (e) => MedicalHistoryEntry(
              title: e['title'] as String? ?? '',
              recordedAt: DateTime.tryParse(e['recordedAt'] as String? ?? '') ??
                  DateTime.fromMillisecondsSinceEpoch(0),
            ),
          )
          .toList(),
      cycles: cycles
          .map(
            (e) => CycleEntry(
              centerName: e['centerName'] as String? ?? '',
              startedAt: DateTime.tryParse(e['startedAt'] as String? ?? '') ??
                  DateTime.fromMillisecondsSinceEpoch(0),
              endedAt: DateTime.tryParse(e['endedAt'] as String? ?? ''),
            ),
          )
          .toList(),
      documents: documents
          .map(
            (e) => PatientDocument(
              id: e['id'] as String? ?? '',
              name: e['name'] as String? ?? '',
              url: e['url'] as String? ?? '',
            ),
          )
          .toList(),
      vitals: vitals
          .map(
            (e) => VitalEntry(
              type: e['type'] as String? ?? '',
              value: e['value'] as String? ?? '',
              recordedAt: DateTime.tryParse(e['recordedAt'] as String? ?? '') ??
                  DateTime.fromMillisecondsSinceEpoch(0),
            ),
          )
          .toList(),
    );
  }
}
