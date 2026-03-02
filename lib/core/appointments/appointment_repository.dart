import 'appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAll();

  Future<Appointment> create(Appointment appointment);

  Future<Appointment?> updateStatus({
    required String appointmentId,
    required AppointmentStatus status,
  });

  Future<bool> hasConflict({
    required String chairNumber,
    required DateTime scheduledAt,
    String? excludingAppointmentId,
  });
}
