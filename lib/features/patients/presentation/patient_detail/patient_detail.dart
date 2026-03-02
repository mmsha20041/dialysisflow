import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';
import 'package:dialysisflow/core/di/service_locator.dart';
import 'package:dialysisflow/features/patients/presentation/controllers/patient_detail_controller.dart';
import './widgets/current_cycle_widget.dart';
import './widgets/documents_widget.dart';
import './widgets/medical_history_widget.dart';
import './widgets/patient_header_widget.dart';
import './widgets/vitals_widget.dart';

class PatientDetail extends StatefulWidget {
  const PatientDetail({Key? key}) : super(key: key);

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  final PatientDetailController _controller =
      PatientDetailController(ServiceLocator.patientRepository);

  Map<String, dynamic> patientData = {};
  List<Map<String, dynamic>> medicalHistory = [];
  Map<String, dynamic>? currentCycle;
  List<Map<String, dynamic>> documents = [];
  List<Map<String, dynamic>> vitalsData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    _loadPatientDetail();
  }

  Future<void> _loadPatientDetail() async {
    final data = await _controller.loadPatientDetail('P001');
    setState(() {
      patientData = Map<String, dynamic>.from(data['patientData'] ?? {});
      medicalHistory = List<Map<String, dynamic>>.from(data['medicalHistory'] ?? []);
      currentCycle = data['currentCycle'] as Map<String, dynamic>?;
      documents = List<Map<String, dynamic>>.from(data['documents'] ?? []);
      vitalsData = List<Map<String, dynamic>>.from(data['vitalsData'] ?? []);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshPatientData,
        child: Column(
          children: [
            _buildPatientHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MedicalHistoryWidget(historyData: medicalHistory),
                  CurrentCycleWidget(currentCycle: currentCycle),
                  DocumentsWidget(documents: documents),
                  VitalsWidget(vitalsData: vitalsData),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        patientData["name"] as String? ?? "Patient Detail",
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showPatientMenu,
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: PatientHeaderWidget(
        patientData: patientData,
        onCall: _makePhoneCall,
        onMessage: _sendMessage,
        onEdit: _editPatient,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(1.w),
        labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'History'),
          Tab(text: 'Current'),
          Tab(text: 'Documents'),
          Tab(text: 'Vitals'),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    String buttonText = 'Action';
    IconData buttonIcon = Icons.add;
    VoidCallback? onPressed;

    switch (_currentTabIndex) {
      case 0: // Medical History
        buttonText = 'Add Note';
        buttonIcon = Icons.note_add;
        onPressed = _addMedicalNote;
        break;
      case 1: // Current Cycle
        if (currentCycle != null) {
          final sessions =
              (currentCycle!["sessions"] as List).cast<Map<String, dynamic>>();
          final hasInProgressSession =
              sessions.any((s) => s["status"] == "in_progress");

          if (hasInProgressSession) {
            buttonText = 'Continue';
            buttonIcon = Icons.play_arrow;
            onPressed = _continueSession;
          } else {
            buttonText = 'Start Session';
            buttonIcon = Icons.play_circle_filled;
            onPressed = _startSession;
          }
        } else {
          buttonText = 'New Cycle';
          buttonIcon = Icons.add_circle;
          onPressed = _startNewCycle;
        }
        break;
      case 2: // Documents
        buttonText = 'Upload';
        buttonIcon = Icons.upload_file;
        onPressed = _uploadDocument;
        break;
      case 3: // Vitals
        buttonText = 'Record';
        buttonIcon = Icons.add_chart;
        onPressed = _recordVitals;
        break;
    }

    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: buttonIcon.toString().split('.').last,
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 5.w,
      ),
      label: Text(buttonText),
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
    );
  }

  Future<void> _refreshPatientData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would fetch fresh data from the API
    setState(() {
      // Refresh data here
    });
  }

  void _makePhoneCall() {
    // This would typically launch the phone dialer
    print('Calling ${patientData["phone"]}');
  }

  void _sendMessage() {
    // This would typically launch the messaging app
    print('Sending message to ${patientData["phone"]}');
  }

  void _editPatient() {
    // This would typically navigate to the patient edit screen
    Navigator.pushNamed(context, '/patient-registration');
  }

  void _showPatientMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('View Full Profile'),
              onTap: () {
                Navigator.pop(context);
                _viewFullProfile();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('Treatment History'),
              onTap: () {
                Navigator.pop(context);
                _viewTreatmentHistory();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('Share Patient Info'),
              onTap: () {
                Navigator.pop(context);
                _sharePatientInfo();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'print',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text('Generate Report'),
              onTap: () {
                Navigator.pop(context);
                _generateReport();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _addMedicalNote() {
    print('Adding medical note...');
  }

  void _continueSession() {
    print('Continuing current session...');
  }

  void _startSession() {
    print('Starting new session...');
  }

  void _startNewCycle() {
    print('Starting new cycle...');
  }

  void _uploadDocument() {
    print('Uploading document...');
  }

  void _recordVitals() {
    print('Recording vitals...');
  }

  void _viewFullProfile() {
    print('Viewing full profile...');
  }

  void _viewTreatmentHistory() {
    print('Viewing treatment history...');
  }

  void _sharePatientInfo() {
    print('Sharing patient info...');
  }

  void _generateReport() {
    print('Generating report...');
  }
}
