import 'appointment.dart';

class AppointmentStatusPolicy {
  static bool canTransition({
    required String role,
    required AppointmentStatus from,
    required AppointmentStatus to,
  }) {
    if (from == to) return true;

    final normalizedRole = role.trim().toLowerCase();

    switch (normalizedRole) {
      case 'staff':
      case 'nurse':
        return _staffAllowedTransitions[from]?.contains(to) ?? false;
      case 'rmo':
      case 'doctor':
        return _doctorAllowedTransitions[from]?.contains(to) ?? false;
      case 'admin':
        return true;
      default:
        return false;
    }
  }

  static const Map<AppointmentStatus, Set<AppointmentStatus>>
      _staffAllowedTransitions = {
    AppointmentStatus.scheduled: {
      AppointmentStatus.checkedIn,
      AppointmentStatus.cancelled,
      AppointmentStatus.missed,
    },
    AppointmentStatus.checkedIn: {
      AppointmentStatus.completed,
      AppointmentStatus.missed,
    },
    AppointmentStatus.completed: {},
    AppointmentStatus.missed: {},
    AppointmentStatus.cancelled: {},
  };

  static const Map<AppointmentStatus, Set<AppointmentStatus>>
      _doctorAllowedTransitions = {
    AppointmentStatus.scheduled: {
      AppointmentStatus.checkedIn,
      AppointmentStatus.cancelled,
      AppointmentStatus.missed,
    },
    AppointmentStatus.checkedIn: {
      AppointmentStatus.completed,
      AppointmentStatus.missed,
      AppointmentStatus.cancelled,
    },
    AppointmentStatus.completed: {},
    AppointmentStatus.missed: {},
    AppointmentStatus.cancelled: {},
  };
}
