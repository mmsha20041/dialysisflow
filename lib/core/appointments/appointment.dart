enum AppointmentStatus {
  scheduled,
  checkedIn,
  completed,
  missed,
  cancelled,
}

class Appointment {
  final String id;
  final String patientName;
  final String chairNumber;
  final DateTime scheduledAt;
  final String sessionType;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.chairNumber,
    required this.scheduledAt,
    required this.sessionType,
    this.status = AppointmentStatus.scheduled,
  });

  Appointment copyWith({
    String? id,
    String? patientName,
    String? chairNumber,
    DateTime? scheduledAt,
    String? sessionType,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      chairNumber: chairNumber ?? this.chairNumber,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      sessionType: sessionType ?? this.sessionType,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'chairNumber': chairNumber,
      'scheduledAt': scheduledAt.toIso8601String(),
      'sessionType': sessionType,
      'status': status.name,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String,
      patientName: map['patientName'] as String,
      chairNumber: map['chairNumber'] as String,
      scheduledAt: DateTime.parse(map['scheduledAt'] as String),
      sessionType: map['sessionType'] as String,
      status: AppointmentStatus.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
    );
  }
}
