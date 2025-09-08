
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/patient_card_widget.dart';
import './widgets/search_bar_widget.dart';

class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isLoading = false;
  bool _isRecording = false;
  bool _isMultiSelectMode = false;
  String _searchQuery = '';
  List<String> _selectedFilters = [];
  List<String> _selectedPatients = [];

  // Mock patient data
  final List<Map<String, dynamic>> _allPatients = [
    {
      "id": 1,
      "name": "Rajesh Kumar",
      "uhid": "DH001234",
      "phone": "+91 9876543210",
      "aadhaar": "1234-5678-9012",
      "status": "Active",
      "lastSession": "Today, 10:30 AM",
      "avatar":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "cycleCount": 3,
      "nextAppointment": "Tomorrow, 9:00 AM"
    },
    {
      "id": 2,
      "name": "Priya Sharma",
      "uhid": "DH001235",
      "phone": "+91 9876543211",
      "aadhaar": "1234-5678-9013",
      "status": "In Session",
      "lastSession": "Today, 8:00 AM",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "cycleCount": 7,
      "nextAppointment": "Dec 10, 2024"
    },
    {
      "id": 3,
      "name": "Mohammed Ali",
      "uhid": "DH001236",
      "phone": "+91 9876543212",
      "aadhaar": "1234-5678-9014",
      "status": "Pending Approval",
      "lastSession": "Dec 6, 2024",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "cycleCount": 1,
      "nextAppointment": "Pending"
    },
    {
      "id": 4,
      "name": "Sunita Devi",
      "uhid": "DH001237",
      "phone": "+91 9876543213",
      "aadhaar": "1234-5678-9015",
      "status": "Discharged",
      "lastSession": "Dec 5, 2024",
      "avatar":
          "https://images.pexels.com/photos/1181519/pexels-photo-1181519.jpeg?auto=compress&cs=tinysrgb&w=400",
      "cycleCount": 9,
      "nextAppointment": "Completed"
    },
    {
      "id": 5,
      "name": "Amit Patel",
      "uhid": "DH001238",
      "phone": "+91 9876543214",
      "aadhaar": "1234-5678-9016",
      "status": "Scheduled",
      "lastSession": "Dec 4, 2024",
      "avatar":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "cycleCount": 2,
      "nextAppointment": "Dec 12, 2024"
    },
    {
      "id": 6,
      "name": "Kavita Singh",
      "uhid": "DH001239",
      "phone": "+91 9876543215",
      "aadhaar": "1234-5678-9017",
      "status": "Active",
      "lastSession": "Yesterday, 2:30 PM",
      "avatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "cycleCount": 5,
      "nextAppointment": "Dec 11, 2024"
    },
  ];

  final List<Map<String, dynamic>> _filterOptions = [
    {"key": "active", "label": "Active Cycles", "count": 2},
    {"key": "pending", "label": "Pending Approval", "count": 1},
    {"key": "discharged", "label": "Discharged", "count": 1},
    {"key": "scheduled", "label": "Scheduled", "count": 1},
    {"key": "in_session", "label": "In Session", "count": 1},
  ];

  List<Map<String, dynamic>> get _filteredPatients {
    List<Map<String, dynamic>> filtered = _allPatients;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((patient) {
        final name = (patient['name'] as String? ?? '').toLowerCase();
        final uhid = (patient['uhid'] as String? ?? '').toLowerCase();
        final phone = (patient['phone'] as String? ?? '').toLowerCase();
        final aadhaar = (patient['aadhaar'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            uhid.contains(query) ||
            phone.contains(query) ||
            aadhaar.contains(query);
      }).toList();
    }

    // Apply status filters
    if (_selectedFilters.isNotEmpty) {
      filtered = filtered.where((patient) {
        final status = (patient['status'] as String? ?? '').toLowerCase();
        return _selectedFilters.any((filter) {
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadPatients();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshPatients() async {
    await _loadPatients();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
  }

  Future<void> _startVoiceSearch() async {
    if (_isRecording) {
      await _stopVoiceSearch();
      return;
    }

    final hasPermission = await Permission.microphone.request().isGranted;
    if (!hasPermission) {
      _showSnackBar('Microphone permission is required for voice search');
      return;
    }

    try {
      setState(() => _isRecording = true);

      String recordPath;
      if (kIsWeb) {
        // For web, we can use a simple filename
        recordPath = 'voice_search_recording.wav';
      } else {
        // For mobile platforms, get temporary directory
        final tempDir = await getTemporaryDirectory();
        recordPath = '${tempDir.path}/voice_search_recording.m4a';
      }

      await _audioRecorder.start(
        const RecordConfig(
            encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
        path: recordPath,
      );

      // Simulate voice recognition after 3 seconds
      await Future.delayed(const Duration(seconds: 3));

      if (_isRecording) {
        await _stopVoiceSearch();
        _searchController.text = 'Rajesh Kumar';
        _onSearchChanged('Rajesh Kumar');
        _showSnackBar('Voice search: "Rajesh Kumar"');
      }
    } catch (e) {
      setState(() => _isRecording = false);
      _showSnackBar('Voice search failed. Please try again.');
    }
  }

  Future<void> _stopVoiceSearch() async {
    try {
      await _audioRecorder.stop();
    } catch (e) {
      // Handle error silently
    } finally {
      setState(() => _isRecording = false);
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filter Patients',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedFilters.clear());
                          setModalState(() {});
                        },
                        child: Text('Clear All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _filterOptions.map((filter) {
                      final isSelected =
                          _selectedFilters.contains(filter['key']);
                      return FilterChip(
                        label: Text('${filter['label']} (${filter['count']})'),
                        selected: isSelected,
                        onSelected: (selected) {
                          _onFilterSelected(filter['key']);
                          setModalState(() {});
                        },
                        selectedColor: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.lightTheme.primaryColor,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onPatientTap(Map<String, dynamic> patient) {
    if (_isMultiSelectMode) {
      _togglePatientSelection(patient['id'].toString());
    } else {
      Navigator.pushNamed(context, '/patient-detail', arguments: patient);
    }
  }

  void _onPatientLongPress(Map<String, dynamic> patient) {
    if (!_isMultiSelectMode) {
      setState(() {
        _isMultiSelectMode = true;
        _selectedPatients.add(patient['id'].toString());
      });
    }
  }

  void _togglePatientSelection(String patientId) {
    setState(() {
      if (_selectedPatients.contains(patientId)) {
        _selectedPatients.remove(patientId);
        if (_selectedPatients.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedPatients.add(patientId);
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedPatients.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showBatchActionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Batch Actions'),
          content: Text('${_selectedPatients.length} patients selected'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar('Batch transfer initiated');
                _exitMultiSelectMode();
              },
              child: Text('Transfer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar('Batch archive initiated');
                _exitMultiSelectMode();
              },
              child: Text('Archive'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar:
          _isMultiSelectMode ? _buildMultiSelectAppBar() : _buildNormalAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isMultiSelectMode) ...[
              SearchBarWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onVoiceSearch:
                    _isRecording ? _stopVoiceSearch : _startVoiceSearch,
                onFilterTap: _showFilterDialog,
                hintText: _isRecording
                    ? 'Listening...'
                    : 'Search patients by name, UHID, phone...',
              ),
              if (_selectedFilters.isNotEmpty)
                FilterChipsWidget(
                  filters: _filterOptions,
                  selectedFilters: _selectedFilters,
                  onFilterSelected: _onFilterSelected,
                ),
            ],
            Expanded(
              child: _isLoading
                  ? const LoadingSkeletonWidget()
                  : _filteredPatients.isEmpty
                      ? EmptyStateWidget(
                          title: _searchQuery.isNotEmpty ||
                                  _selectedFilters.isNotEmpty
                              ? 'No patients found'
                              : 'No patients yet',
                          subtitle: _searchQuery.isNotEmpty ||
                                  _selectedFilters.isNotEmpty
                              ? 'Try adjusting your search or filters'
                              : 'Add your first patient to get started with dialysis management',
                          buttonText:
                              _searchQuery.isEmpty && _selectedFilters.isEmpty
                                  ? 'Add First Patient'
                                  : null,
                          onButtonPressed:
                              _searchQuery.isEmpty && _selectedFilters.isEmpty
                                  ? () => Navigator.pushNamed(
                                      context, '/patient-registration')
                                  : null,
                          iconName: _searchQuery.isNotEmpty ||
                                  _selectedFilters.isNotEmpty
                              ? 'search_off'
                              : 'people_outline',
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshPatients,
                          child: ListView.builder(
                            itemCount: _filteredPatients.length,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            itemBuilder: (context, index) {
                              final patient = _filteredPatients[index];
                              final isSelected = _selectedPatients
                                  .contains(patient['id'].toString());

                              return PatientCardWidget(
                                patient: patient,
                                isSelected: isSelected,
                                onTap: () => _onPatientTap(patient),
                                onLongPress: () => _onPatientLongPress(patient),
                                onStartSession: () {
                                  _showSnackBar(
                                      'Starting session for ${patient['name']}');
                                },
                                onViewRecords: () {
                                  _showSnackBar(
                                      'Opening records for ${patient['name']}');
                                },
                                onCallPatient: () {
                                  _showSnackBar('Calling ${patient['name']}');
                                },
                                onEditDetails: () {
                                  _showSnackBar('Editing ${patient['name']}');
                                },
                                onTransferCenter: () {
                                  _showSnackBar(
                                      'Transferring ${patient['name']}');
                                },
                                onArchive: () {
                                  _showSnackBar('Archiving ${patient['name']}');
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed(context, '/patient-registration'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text('New Patient'),
            ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: Text('Patients'),
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Patients'),
          Tab(text: 'Sessions'),
          Tab(text: 'Reports'),
          Tab(text: 'Analytics'),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _refreshPatients,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildMultiSelectAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _exitMultiSelectMode,
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text('${_selectedPatients.length} selected'),
      actions: [
        IconButton(
          onPressed: _showBatchActionsDialog,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
    );
  }
}
