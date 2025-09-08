import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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

  // Mock patient data
  final Map<String, dynamic> patientData = {
    "id": "P001",
    "name": "Rajesh Kumar",
    "uhid": "UH2024001",
    "age": 58,
    "gender": "Male",
    "avatar":
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
    "currentStatus": "active",
    "tmsId": "TMS2024001",
    "phone": "+91 9876543210",
    "email": "rajesh.kumar@email.com",
    "address": "123 MG Road, Bangalore, Karnataka 560001",
    "emergencyContact": "+91 9876543211",
    "bloodGroup": "B+",
    "dateOfBirth": "1965-03-15",
    "aadhaarNumber": "1234 5678 9012",
    "pmjayId": "PMJAY123456789"
  };

  // Mock medical history data
  final List<Map<String, dynamic>> medicalHistory = [
    {
      "id": "H001",
      "cycleType": "Hemodialysis",
      "diagnosis": "Chronic Kidney Disease Stage 5",
      "treatment":
          "Regular hemodialysis sessions with fluid management and dietary modifications",
      "startDate": "2024-01-15",
      "endDate": "2024-03-15",
      "status": "completed",
      "completedSessions": 36,
      "totalSessions": 36,
      "duration": "3 months",
      "doctor": "Dr. Priya Sharma"
    },
    {
      "id": "H002",
      "cycleType": "Peritoneal Dialysis",
      "diagnosis": "End Stage Renal Disease",
      "treatment":
          "Continuous ambulatory peritoneal dialysis with regular monitoring",
      "startDate": "2023-08-10",
      "endDate": "2023-12-10",
      "status": "completed",
      "completedSessions": 120,
      "totalSessions": 120,
      "duration": "4 months",
      "doctor": "Dr. Amit Patel"
    }
  ];

  // Mock current cycle data
  final Map<String, dynamic>? currentCycle = {
    "id": "C003",
    "cycleType": "Hemodialysis",
    "diagnosis": "Chronic Kidney Disease with fluid overload",
    "startDate": "2024-09-01",
    "tmsId": "TMS2024001",
    "status": "active",
    "sessions": [
      {
        "id": "S001",
        "sessionNumber": 1,
        "status": "completed",
        "scheduledDate": "01/09/2024",
        "duration": "4 hours"
      },
      {
        "id": "S002",
        "sessionNumber": 2,
        "status": "completed",
        "scheduledDate": "03/09/2024",
        "duration": "4 hours"
      },
      {
        "id": "S003",
        "sessionNumber": 3,
        "status": "in_progress",
        "scheduledDate": "05/09/2024",
        "duration": "4 hours"
      },
      {
        "id": "S004",
        "sessionNumber": 4,
        "status": "scheduled",
        "scheduledDate": "07/09/2024",
        "duration": "4 hours"
      },
      {
        "id": "S005",
        "sessionNumber": 5,
        "status": "scheduled",
        "scheduledDate": "09/09/2024",
        "duration": "4 hours"
      }
    ]
  };

  // Mock documents data
  final List<Map<String, dynamic>> documents = [
    {
      "id": "D001",
      "fileName": "Lab_Report_Sept_2024.pdf",
      "category": "Lab Reports",
      "uploadDate": "2024-09-05",
      "fileSize": "2.5 MB",
      "thumbnailUrl":
          "https://images.pexels.com/photos/4386466/pexels-photo-4386466.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "id": "D002",
      "fileName": "OPD_Consultation_Aug_2024.pdf",
      "category": "OPD Reports",
      "uploadDate": "2024-08-28",
      "fileSize": "1.8 MB",
      "thumbnailUrl": null
    },
    {
      "id": "D003",
      "fileName": "Prescription_Current.pdf",
      "category": "Prescriptions",
      "uploadDate": "2024-09-01",
      "fileSize": "0.8 MB",
      "thumbnailUrl": null
    },
    {
      "id": "D004",
      "fileName": "Insurance_Card.jpg",
      "category": "Insurance",
      "uploadDate": "2024-08-15",
      "fileSize": "1.2 MB",
      "thumbnailUrl":
          "https://images.pexels.com/photos/4386466/pexels-photo-4386466.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "id": "D005",
      "fileName": "Discharge_Summary_March_2024.pdf",
      "category": "Discharge Summary",
      "uploadDate": "2024-03-20",
      "fileSize": "3.1 MB",
      "thumbnailUrl": null
    }
  ];

  // Mock vitals data
  final List<Map<String, dynamic>> vitalsData = [
    {
      "id": "V001",
      "type": "Blood Pressure",
      "value": "120/80",
      "unit": "mmHg",
      "timestamp": "2024-09-08T10:30:00Z",
      "status": "normal"
    },
    {
      "id": "V002",
      "type": "Heart Rate",
      "value": "72",
      "unit": "bpm",
      "timestamp": "2024-09-08T10:30:00Z",
      "status": "normal"
    },
    {
      "id": "V003",
      "type": "Temperature",
      "value": "98.6",
      "unit": "°F",
      "timestamp": "2024-09-08T10:30:00Z",
      "status": "normal"
    },
    {
      "id": "V004",
      "type": "Weight",
      "value": "70.5",
      "unit": "kg",
      "timestamp": "2024-09-08T10:30:00Z",
      "status": "normal"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
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
