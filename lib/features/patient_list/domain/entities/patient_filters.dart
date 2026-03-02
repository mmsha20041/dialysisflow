class PatientFilters {
  PatientFilters({
    this.search,
    this.center,
    this.status,
  });

  final String? search;
  final String? center;
  final String? status;

  Map<String, dynamic> toQueryParameters() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (center != null && center!.isNotEmpty) 'center': center,
      if (status != null && status!.isNotEmpty) 'status': status,
    };
  }
}
