class AppointmentValidator {
  static String? validatePatientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Patient name is required';
    }
    return null;
  }

  static String? validateChairNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Chair number is required';
    }

    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return 'Chair number must be a positive number';
    }

    return null;
  }
}
