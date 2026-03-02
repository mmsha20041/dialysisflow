import 'package:flutter_test/flutter_test.dart';
import 'package:dialysisflow/core/appointments/appointment.dart';
import 'package:dialysisflow/core/appointments/appointment_use_cases.dart';
import 'package:dialysisflow/core/appointments/in_memory_appointment_repository.dart';

void main() {
  group('AppointmentUseCases', () {
    test('rejects create when conflict exists', () async {
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

      final useCases = AppointmentUseCases(repository);

      final error = await useCases.createAppointment(
        patientName: 'Asha',
        chairNumber: '3',
        scheduledAt: DateTime(2026, 1, 15, 9, 0),
        sessionType: 'HDF',
      );

      expect(error, isNotNull);
    });

    test('creates appointment when no conflict exists', () async {
      final repository = InMemoryAppointmentRepository();
      final useCases = AppointmentUseCases(repository);

      final error = await useCases.createAppointment(
        patientName: 'Asha',
        chairNumber: '3',
        scheduledAt: DateTime(2026, 1, 15, 9, 0),
        sessionType: 'HDF',
      );

      final all = await repository.getAll();

      expect(error, isNull);
      expect(all.length, 1);
    });
  });
}
