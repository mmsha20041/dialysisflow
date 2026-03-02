import 'appointment.dart';
import 'appointment_repository.dart';
import 'appointment_status_policy.dart';

class AppointmentUseCases {
  final AppointmentRepository _repository;

  AppointmentUseCases(this._repository);

  Future<List<Appointment>> listAppointments() {
    return _repository.getAll();
  }

  Future<String?> createAppointment({
    required String patientName,
    required String chairNumber,
    required DateTime scheduledAt,
    required String sessionType,
  }) async {
    final hasConflict = await _repository.hasConflict(
      chairNumber: chairNumber,
      scheduledAt: scheduledAt,
    );

    if (hasConflict) {
      return 'Chair already booked for the selected date and time.';
    }

    await _repository.create(
      Appointment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        patientName: patientName,
        chairNumber: chairNumber,
        scheduledAt: scheduledAt,
        sessionType: sessionType,
      ),
    );

    return null;
  }

  Future<String?> updateAppointmentStatus({
    required String role,
    required Appointment appointment,
    required AppointmentStatus to,
  }) async {
    final allowed = AppointmentStatusPolicy.canTransition(
      role: role,
      from: appointment.status,
      to: to,
    );

    if (!allowed) {
      return 'You are not allowed to update status to ${to.name}.';
    }

    await _repository.updateStatus(
      appointmentId: appointment.id,
      status: to,
    );

    return null;
  }
}
