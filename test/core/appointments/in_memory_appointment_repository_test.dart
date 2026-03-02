import 'package:flutter_test/flutter_test.dart';
import 'package:dialysisflow/core/appointments/appointment.dart';
import 'package:dialysisflow/core/appointments/in_memory_appointment_repository.dart';

void main() {
  group('InMemoryAppointmentRepository', () {
    test('detects conflict for same chair and same minute', () async {
      final scheduledAt = DateTime(2026, 1, 15, 9, 0);
      final repository = InMemoryAppointmentRepository(
        seedAppointments: [
          Appointment(
            id: 'a1',
            patientName: 'Rahul',
            chairNumber: '3',
            scheduledAt: scheduledAt,
            sessionType: 'Standard HD',
          ),
        ],
      );

      final hasConflict = await repository.hasConflict(
        chairNumber: '3',
        scheduledAt: DateTime(2026, 1, 15, 9, 0),
      );

      expect(hasConflict, isTrue);
    });

    test('ignores cancelled appointments for conflict checks', () async {
      final repository = InMemoryAppointmentRepository(
        seedAppointments: [
          Appointment(
            id: 'a1',
            patientName: 'Rahul',
            chairNumber: '3',
            scheduledAt: DateTime(2026, 1, 15, 9, 0),
            sessionType: 'Standard HD',
            status: AppointmentStatus.cancelled,
          ),
        ],
      );

      final hasConflict = await repository.hasConflict(
        chairNumber: '3',
        scheduledAt: DateTime(2026, 1, 15, 9, 0),
      );

      expect(hasConflict, isFalse);
    });

    test('updates appointment status', () async {
      final repository = InMemoryAppointmentRepository(
        seedAppointments: [
          Appointment(
            id: 'a1',
            patientName: 'Rahul',
            chairNumber: '3',
            scheduledAt: DateTime(2026, 1, 15, 9, 0),
            sessionType: 'Standard HD',
          ),
        ],
      );

      final updated = await repository.updateStatus(
        appointmentId: 'a1',
        status: AppointmentStatus.completed,
      );

      expect(updated, isNotNull);
      expect(updated!.status, AppointmentStatus.completed);
    });
  });
}
