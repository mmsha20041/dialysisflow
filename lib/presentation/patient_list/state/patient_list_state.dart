class PatientListViewData {
  const PatientListViewData({
    this.allPatients = const [],
    this.filterOptions = const [],
    this.searchQuery = '',
    this.selectedFilters = const [],
    this.selectedPatients = const [],
    this.isRecording = false,
    this.isMultiSelectMode = false,
  });

  final List<Map<String, dynamic>> allPatients;
  final List<Map<String, dynamic>> filterOptions;
  final String searchQuery;
  final List<String> selectedFilters;
  final List<String> selectedPatients;
  final bool isRecording;
  final bool isMultiSelectMode;

  List<Map<String, dynamic>> get filteredPatients {
    var filtered = allPatients;

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((patient) {
        final name = (patient['name'] as String? ?? '').toLowerCase();
        final uhid = (patient['uhid'] as String? ?? '').toLowerCase();
        final phone = (patient['phone'] as String? ?? '').toLowerCase();
        final aadhaar = (patient['aadhaar'] as String? ?? '').toLowerCase();
        final query = searchQuery.toLowerCase();

        return name.contains(query) ||
            uhid.contains(query) ||
            phone.contains(query) ||
            aadhaar.contains(query);
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      filtered = filtered.where((patient) {
        final status = (patient['status'] as String? ?? '').toLowerCase();
        return selectedFilters.any((filter) {
          switch (filter) {
            case 'active':
              return status == 'active';
            case 'pending':
              return status == 'pending approval';
            case 'discharged':
              return status == 'discharged';
            case 'scheduled':
              return status == 'scheduled';
            case 'in_session':
              return status == 'in session';
            default:
              return false;
          }
        });
      }).toList();
    }

    return filtered;
  }

  PatientListViewData copyWith({
    List<Map<String, dynamic>>? allPatients,
    List<Map<String, dynamic>>? filterOptions,
    String? searchQuery,
    List<String>? selectedFilters,
    List<String>? selectedPatients,
    bool? isRecording,
    bool? isMultiSelectMode,
  }) {
    return PatientListViewData(
      allPatients: allPatients ?? this.allPatients,
      filterOptions: filterOptions ?? this.filterOptions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      selectedPatients: selectedPatients ?? this.selectedPatients,
      isRecording: isRecording ?? this.isRecording,
      isMultiSelectMode: isMultiSelectMode ?? this.isMultiSelectMode,
    );
  }
}

sealed class PatientListState {
  const PatientListState(this.data);

  final PatientListViewData data;
}

class PatientListEmpty extends PatientListState {
  const PatientListEmpty([super.data = const PatientListViewData()]);
}

class PatientListLoading extends PatientListState {
  const PatientListLoading(super.data);
}

class PatientListSuccess extends PatientListState {
  const PatientListSuccess(super.data, {this.message});

  final String? message;
}

class PatientListError extends PatientListState {
  const PatientListError(super.data, this.message);

  final String message;
}
