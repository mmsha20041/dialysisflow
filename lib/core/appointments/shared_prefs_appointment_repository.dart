import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'appointment.dart';
import 'appointment_repository.dart';

class SharedPrefsAppointmentRepository implements AppointmentRepository {
  static const _appointmentsKey = 'appointments.v1';

  final SharedPreferences _prefs;

  SharedPrefsAppointmentRepository(this._prefs);

  static Future<SharedPrefsAppointmentRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsAppointmentRepository(prefs);
  }

  @override
  Future<Appointment> create(Appointment appointment) async {
    final appointments = await getAll();
    final updated = [appointment, ...appointments];
    await _save(updated);
    return appointment;
  }

  @override
  Future<List<Appointment>> getAll() async {
    final raw = _prefs.getString(_appointmentsKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => Appointment.fromMap(entry as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<bool> hasConflict({
    required String chairNumber,
    required DateTime scheduledAt,
    String? excludingAppointmentId,
  }) async {
    final appointments = await getAll();
    final normalizedChair = chairNumber.trim().toLowerCase();

    return appointments.any((appointment) {
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
    final appointments = await getAll();
    final index = appointments.indexWhere((item) => item.id == appointmentId);
    if (index < 0) return null;

    final mutable = [...appointments];
    final updated = mutable[index].copyWith(status: status);
    mutable[index] = updated;
    await _save(mutable);
    return updated;
  }

  Future<void> _save(List<Appointment> appointments) async {
    final payload = jsonEncode(appointments.map((e) => e.toMap()).toList());
    await _prefs.setString(_appointmentsKey, payload);
  }

  bool _isSameMinute(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day &&
        first.hour == second.hour &&
        first.minute == second.minute;
  }
}
