import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:dialysisflow/core/app_export.dart';
import './widgets/biometric_consent_section.dart';
import './widgets/document_upload_section.dart';
import './widgets/emergency_contact_section.dart';
import './widgets/government_id_section.dart';
import './widgets/medical_information_section.dart';
import './widgets/personal_details_section.dart';
import './widgets/photo_capture_section.dart';

class PatientRegistration extends StatefulWidget {
  const PatientRegistration({Key? key}) : super(key: key);

  @override
  State<PatientRegistration> createState() => _PatientRegistrationState();
}

class _PatientRegistrationState extends State<PatientRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Form Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _pmjayController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _currentMedicationsController =
      TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _emergencyRelationController =
      TextEditingController();

  // Form State Variables
  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedBloodGroup;
  bool _isAadhaarVerifying = false;
  bool _isAadhaarVerified = false;
  bool _isPmjayScanning = false;
  XFile? _capturedImage;
  List<PlatformFile> _uploadedDocuments = [];
  bool _biometricConsent = false;

  // UI State Variables
  int _currentStep = 0;
  bool _isRegistering = false;
  String? _generatedUHID;

  final List<String> _stepTitles = [
    'Personal Details',
    'Government IDs',
    'Medical Info',
    'Emergency Contact',
    'Photo & Documents',
    'Review & Submit'
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _aadhaarController.dispose();
    _pmjayController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme,
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _verifyAadhaar() async {
    if (_aadhaarController.text.length != 12) {
      _showErrorMessage('Please enter a valid 12-digit Aadhaar number');
      return;
    }

    setState(() {
      _isAadhaarVerifying = true;
    });

    // Simulate API call for Aadhaar verification
    await Future.delayed(const Duration(seconds: 2));

    // Mock verification logic
    final aadhaarNumber = _aadhaarController.text;
    final isValid = aadhaarNumber.startsWith('2') ||
        aadhaarNumber.startsWith('3') ||
        aadhaarNumber.startsWith('4');

    setState(() {
      _isAadhaarVerifying = false;
      _isAadhaarVerified = isValid;
    });

    if (isValid) {
      _showSuccessMessage('Aadhaar verified successfully');
      // Auto-fill some demo data
      if (_firstNameController.text.isEmpty) {
        _firstNameController.text = 'Rajesh';
        _lastNameController.text = 'Kumar';
        _selectedGender = 'Male';
        _selectedDate = DateTime(1985, 5, 15);
      }
    } else {
      _showErrorMessage(
          'Aadhaar verification failed. Please check the number and try again.');
    }
  }

  Future<void> _scanPmjayCard() async {
    setState(() {
      _isPmjayScanning = true;
    });

    // Simulate camera scanning
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isPmjayScanning = false;
    });

    // Mock PMJAY card data extraction
    _pmjayController.text =
        'PMJAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _showSuccessMessage('PMJAY card scanned successfully');
  }

  void _onImageCaptured(XFile? image) {
    setState(() {
      _capturedImage = image;
    });
  }

  void _onDocumentsChanged(List<PlatformFile> documents) {
    setState(() {
      _uploadedDocuments = documents;
    });
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Personal Details
        return _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty &&
            _phoneController.text.length == 10 &&
            _selectedDate != null &&
            _selectedGender != null &&
            _addressController.text.isNotEmpty;
      case 1: // Government IDs
        return _aadhaarController.text.length == 12 && _isAadhaarVerified;
      case 2: // Medical Info
        return _selectedBloodGroup != null;
      case 3: // Emergency Contact
        return _emergencyNameController.text.isNotEmpty &&
            _emergencyPhoneController.text.length == 10 &&
            _emergencyRelationController.text.isNotEmpty;
      case 4: // Photo & Documents
        return _capturedImage != null;
      default:
        return true;
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _stepTitles.length - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _showErrorMessage(
          'Please complete all required fields before proceeding');
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _registerPatient() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorMessage('Please complete all required fields');
      return;
    }

    setState(() {
      _isRegistering = true;
    });

    // Simulate registration process
    await Future.delayed(const Duration(seconds: 3));

    // Generate UHID
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _generatedUHID = 'UHID${timestamp.substring(timestamp.length - 8)}';

    setState(() {
      _isRegistering = false;
    });

    _showRegistrationSuccess();
  }

  void _showRegistrationSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Registration Successful!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Patient UHID',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _generatedUHID ?? '',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Patient has been successfully registered in the DialysisFlow system. The UHID will be used for all future medical records and appointments.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/patient-list');
              },
              child: Text(
                'View Patient List',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            children: List.generate(_stepTitles.length, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 16,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: isCurrent
                                        ? AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _stepTitles[index],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isCurrent
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isCurrent ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _stepTitles.length,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Registration Details',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          _buildReviewCard(
            'Personal Information',
            [
              'Name: ${_firstNameController.text} ${_lastNameController.text}',
              'Date of Birth: ${_selectedDate != null ? "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}" : "Not selected"}',
              'Gender: ${_selectedGender ?? "Not selected"}',
              'Phone: ${_phoneController.text}',
              'Email: ${_emailController.text.isEmpty ? "Not provided" : _emailController.text}',
              'Address: ${_addressController.text}',
            ],
          ),
          _buildReviewCard(
            'Government IDs',
            [
              'Aadhaar: ${_aadhaarController.text} ${_isAadhaarVerified ? "(Verified)" : "(Not verified)"}',
              'PMJAY: ${_pmjayController.text.isEmpty ? "Not provided" : _pmjayController.text}',
            ],
          ),
          _buildReviewCard(
            'Medical Information',
            [
              'Blood Group: ${_selectedBloodGroup ?? "Not selected"}',
              'Medical History: ${_medicalHistoryController.text.isEmpty ? "None provided" : _medicalHistoryController.text}',
              'Allergies: ${_allergiesController.text.isEmpty ? "None reported" : _allergiesController.text}',
              'Current Medications: ${_currentMedicationsController.text.isEmpty ? "None reported" : _currentMedicationsController.text}',
            ],
          ),
          _buildReviewCard(
            'Emergency Contact',
            [
              'Name: ${_emergencyNameController.text}',
              'Phone: ${_emergencyPhoneController.text}',
              'Relationship: ${_emergencyRelationController.text}',
            ],
          ),
          _buildReviewCard(
            'Documents & Photo',
            [
              'Patient Photo: ${_capturedImage != null ? "Captured" : "Not captured"}',
              'Documents: ${_uploadedDocuments.length} files uploaded',
              'Biometric Consent: ${_biometricConsent ? "Granted" : "Not granted"}',
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String title, List<String> details) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 2.h),
          ...details.map((detail) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Text(
                  detail,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'New Patient Registration',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: PersonalDetailsSection(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      addressController: _addressController,
                      selectedDate: _selectedDate,
                      selectedGender: _selectedGender,
                      onDateTap: _selectDate,
                      onGenderChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),
                  ),
                  SingleChildScrollView(
                    child: GovernmentIdSection(
                      aadhaarController: _aadhaarController,
                      pmjayController: _pmjayController,
                      isAadhaarVerifying: _isAadhaarVerifying,
                      isAadhaarVerified: _isAadhaarVerified,
                      isPmjayScanning: _isPmjayScanning,
                      onAadhaarVerify: _verifyAadhaar,
                      onPmjayScan: _scanPmjayCard,
                    ),
                  ),
                  SingleChildScrollView(
                    child: MedicalInformationSection(
                      medicalHistoryController: _medicalHistoryController,
                      allergiesController: _allergiesController,
                      currentMedicationsController:
                          _currentMedicationsController,
                      selectedBloodGroup: _selectedBloodGroup,
                      onBloodGroupChanged: (value) =>
                          setState(() => _selectedBloodGroup = value),
                    ),
                  ),
                  SingleChildScrollView(
                    child: EmergencyContactSection(
                      emergencyNameController: _emergencyNameController,
                      emergencyPhoneController: _emergencyPhoneController,
                      emergencyRelationController: _emergencyRelationController,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        PhotoCaptureSection(
                          capturedImage: _capturedImage,
                          onImageCaptured: _onImageCaptured,
                        ),
                        DocumentUploadSection(
                          uploadedDocuments: _uploadedDocuments,
                          onDocumentsChanged: _onDocumentsChanged,
                        ),
                        BiometricConsentSection(
                          biometricConsent: _biometricConsent,
                          onConsentChanged: (value) =>
                              setState(() => _biometricConsent = value),
                        ),
                      ],
                    ),
                  ),
                  _buildReviewSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    child: Text(
                      'Previous',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
              ],
              Expanded(
                flex: _currentStep > 0 ? 1 : 2,
                child: ElevatedButton(
                  onPressed: _isRegistering
                      ? null
                      : (_currentStep == _stepTitles.length - 1
                          ? _registerPatient
                          : _nextStep),
                  child: _isRegistering
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 4.w,
                              height: 4.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Registering...',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          _currentStep == _stepTitles.length - 1
                              ? 'Register Patient'
                              : 'Next',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
