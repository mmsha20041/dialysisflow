import 'package:flutter_test/flutter_test.dart';
import 'package:dialysisflow/core/appointments/appointment_validator.dart';

void main() {
  group('AppointmentValidator', () {
    test('requires patient name', () {
      expect(
        AppointmentValidator.validatePatientName('   '),
        'Patient name is required',
      );
    });

    test('accepts valid patient name', () {
      expect(AppointmentValidator.validatePatientName('Asha Rani'), isNull);
    });

    test('requires positive chair number', () {
      expect(
        AppointmentValidator.validateChairNumber('0'),
        'Chair number must be a positive number',
      );
      expect(
        AppointmentValidator.validateChairNumber('-1'),
        'Chair number must be a positive number',
      );
      expect(
        AppointmentValidator.validateChairNumber('abc'),
        'Chair number must be a positive number',
      );
    });

    test('accepts valid chair number', () {
      expect(AppointmentValidator.validateChairNumber('4'), isNull);
    });
  });
}
