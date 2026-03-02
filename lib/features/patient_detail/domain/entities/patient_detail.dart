class PatientDetail {
  PatientDetail({
    required this.patientId,
    required this.history,
    required this.cycles,
    required this.documents,
    required this.vitals,
  });

  final String patientId;
  final List<MedicalHistoryEntry> history;
  final List<CycleEntry> cycles;
  final List<PatientDocument> documents;
  final List<VitalEntry> vitals;
}

class MedicalHistoryEntry {
  MedicalHistoryEntry({required this.title, required this.recordedAt});

  final String title;
  final DateTime recordedAt;
}

class CycleEntry {
  CycleEntry({required this.centerName, required this.startedAt, this.endedAt});

  final String centerName;
  final DateTime startedAt;
  final DateTime? endedAt;
}

class PatientDocument {
  PatientDocument({required this.id, required this.name, required this.url});

  final String id;
  final String name;
  final String url;
}

class VitalEntry {
  VitalEntry({required this.type, required this.value, required this.recordedAt});

  final String type;
  final String value;
  final DateTime recordedAt;
}
