import 'package:flutter_test/flutter_test.dart';
import 'package:dialysisflow/core/appointments/appointment.dart';
import 'package:dialysisflow/core/appointments/appointment_status_policy.dart';

void main() {
  group('AppointmentStatusPolicy', () {
    test('allows staff to move scheduled to checked-in', () {
      expect(
        AppointmentStatusPolicy.canTransition(
          role: 'staff',
          from: AppointmentStatus.scheduled,
          to: AppointmentStatus.checkedIn,
        ),
        isTrue,
      );
    });

    test('blocks staff from directly completing scheduled appointment', () {
      expect(
        AppointmentStatusPolicy.canTransition(
          role: 'staff',
          from: AppointmentStatus.scheduled,
          to: AppointmentStatus.completed,
        ),
        isFalse,
      );
    });

    test('allows admin transition', () {
      expect(
        AppointmentStatusPolicy.canTransition(
          role: 'admin',
          from: AppointmentStatus.scheduled,
          to: AppointmentStatus.completed,
        ),
        isTrue,
      );
    });
  });
}
