class Patient {
  Patient({
    required this.id,
    required this.fullName,
    required this.mrn,
    required this.center,
    required this.status,
    this.nextSessionAt,
  });

  final String id;
  final String fullName;
  final String mrn;
  final String center;
  final String status;
  final DateTime? nextSessionAt;
}
