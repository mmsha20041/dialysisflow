import 'appointment.dart';
import 'appointment_repository.dart';

class InMemoryAppointmentRepository implements AppointmentRepository {
  final List<Appointment> _appointments;

  InMemoryAppointmentRepository({List<Appointment>? seedAppointments})
      : _appointments = [...?seedAppointments];

  @override
  Future<Appointment> create(Appointment appointment) async {
    _appointments.insert(0, appointment);
    return appointment;
  }

  @override
  Future<List<Appointment>> getAll() async {
    return List.unmodifiable(_appointments);
  }

  @override
  Future<bool> hasConflict({
    required String chairNumber,
    required DateTime scheduledAt,
    String? excludingAppointmentId,
  }) async {
    final normalizedChair = chairNumber.trim().toLowerCase();

    return _appointments.any((appointment) {
      final sameAppointment = excludingAppointmentId != null &&
          appointment.id == excludingAppointmentId;
      final sameChair =
          appointment.chairNumber.trim().toLowerCase() == normalizedChair;
      final sameSlot = _isSameMinute(appointment.scheduledAt, scheduledAt);
      final isActive = appointment.status != AppointmentStatus.cancelled;

      return !sameAppointment && sameChair && sameSlot && isActive;
    });
  }

  @override
  Future<Appointment?> updateStatus({
    required String appointmentId,
    required AppointmentStatus status,
  }) async {
    final index = _appointments.indexWhere((item) => item.id == appointmentId);
    if (index < 0) return null;

    final updated = _appointments[index].copyWith(status: status);
    _appointments[index] = updated;
    return updated;
  }

  bool _isSameMinute(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
  }
}
