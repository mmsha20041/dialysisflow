import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'patient_list_state.dart';

final patientListControllerProvider =
    StateNotifierProvider.autoDispose<PatientListController, PatientListState>(
  (ref) => PatientListController()..initialize(),
);

class PatientListController extends StateNotifier<PatientListState> {
  PatientListController() : super(const PatientListEmpty());

  final AudioRecorder _audioRecorder = AudioRecorder();

  static const _allPatients = [
    {
      'id': 1,
      'name': 'Rajesh Kumar',
      'uhid': 'DH001234',
      'phone': '+91 9876543210',
      'aadhaar': '1234-5678-9012',
      'status': 'Active',
      'lastSession': 'Today, 10:30 AM',
      'avatar':
          'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400',
      'cycleCount': 3,
      'nextAppointment': 'Tomorrow, 9:00 AM'
    },
    {
      'id': 2,
      'name': 'Priya Sharma',
      'uhid': 'DH001235',
      'phone': '+91 9876543211',
      'aadhaar': '1234-5678-9013',
      'status': 'In Session',
      'lastSession': 'Today, 8:00 AM',
      'avatar':
          'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400',
      'cycleCount': 7,
      'nextAppointment': 'Dec 10, 2024'
    },
    {
      'id': 3,
      'name': 'Mohammed Ali',
      'uhid': 'DH001236',
      'phone': '+91 9876543212',
      'aadhaar': '1234-5678-9014',
      'status': 'Pending Approval',
      'lastSession': 'Dec 6, 2024',
      'avatar':
          'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400',
      'cycleCount': 1,
      'nextAppointment': 'Pending'
    },
  ];

  static const _filterOptions = [
    {'key': 'active', 'label': 'Active Cycles', 'count': 2},
    {'key': 'pending', 'label': 'Pending Approval', 'count': 1},
    {'key': 'discharged', 'label': 'Discharged', 'count': 1},
    {'key': 'scheduled', 'label': 'Scheduled', 'count': 1},
    {'key': 'in_session', 'label': 'In Session', 'count': 1},
  ];

  Future<void> initialize() async {
    state = PatientListLoading(state.data);
    await Future.delayed(const Duration(milliseconds: 900));

    final data = state.data.copyWith(
      allPatients: _allPatients,
      filterOptions: _filterOptions,
    );

    if (data.filteredPatients.isEmpty) {
      state = PatientListEmpty(data);
    } else {
      state = PatientListSuccess(data);
    }
  }

  Future<void> refresh() => initialize();

  void onSearchChanged(String query) {
    final data = state.data.copyWith(searchQuery: query);
    _emitFromData(data);
  }

  void onFilterSelected(String filter) {
    final updated = [...state.data.selectedFilters];
    if (updated.contains(filter)) {
      updated.remove(filter);
    } else {
      updated.add(filter);
    }
    _emitFromData(state.data.copyWith(selectedFilters: updated));
  }

  void clearFilters() {
    _emitFromData(state.data.copyWith(selectedFilters: []));
  }

  void onPatientLongPress(Map<String, dynamic> patient) {
    if (state.data.isMultiSelectMode) return;
    final id = patient['id'].toString();
    _emitFromData(state.data.copyWith(
      isMultiSelectMode: true,
      selectedPatients: [id],
    ));
  }

  void onPatientTap(Map<String, dynamic> patient) {
    if (!state.data.isMultiSelectMode) return;
    togglePatientSelection(patient['id'].toString());
  }

  void togglePatientSelection(String patientId) {
    final selected = [...state.data.selectedPatients];
    if (selected.contains(patientId)) {
      selected.remove(patientId);
    } else {
      selected.add(patientId);
    }

    _emitFromData(state.data.copyWith(
      selectedPatients: selected,
      isMultiSelectMode: selected.isNotEmpty,
    ));
  }

  void exitMultiSelectMode() {
    _emitFromData(state.data.copyWith(
      isMultiSelectMode: false,
      selectedPatients: [],
    ));
  }

  Future<void> startOrStopVoiceSearch() async {
    if (state.data.isRecording) {
      await _stopVoiceSearch();
      return;
    }

    final hasPermission = await Permission.microphone.request().isGranted;
    if (!hasPermission) {
      state = PatientListError(
        state.data,
        'Microphone permission is required for voice search',
      );
      return;
    }

    try {
      state = PatientListLoading(state.data.copyWith(isRecording: true));
      String recordPath;

      if (kIsWeb) {
        recordPath = 'voice_search_recording.wav';
      } else {
        final tempDir = await getTemporaryDirectory();
        recordPath = '${tempDir.path}/voice_search_recording.m4a';
      }

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: recordPath,
      );

      await Future.delayed(const Duration(seconds: 3));
      await _stopVoiceSearch();
      final data = state.data.copyWith(searchQuery: 'Rajesh Kumar');
      state = PatientListSuccess(data, message: 'Voice search: "Rajesh Kumar"');
    } catch (_) {
      _emitFromData(state.data.copyWith(isRecording: false));
      state = PatientListError(state.data, 'Voice search failed. Please try again.');
    }
  }

  Future<void> _stopVoiceSearch() async {
    try {
      await _audioRecorder.stop();
    } catch (_) {
      // ignore
    }

    _emitFromData(state.data.copyWith(isRecording: false));
  }

  void _emitFromData(PatientListViewData data) {
    if (data.filteredPatients.isEmpty) {
      state = PatientListEmpty(data);
      return;
    }
    state = PatientListSuccess(data);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }
}
