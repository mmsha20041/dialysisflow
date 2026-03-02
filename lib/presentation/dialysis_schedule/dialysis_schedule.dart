import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/appointments/appointment.dart';
import '../../core/appointments/appointment_use_cases.dart';
import '../../core/appointments/appointment_validator.dart';
import '../../core/appointments/in_memory_appointment_repository.dart';

class DialysisSchedule extends StatefulWidget {
  const DialysisSchedule({super.key});

  @override
  State<DialysisSchedule> createState() => _DialysisScheduleState();
}

class _DialysisScheduleState extends State<DialysisSchedule> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _chairNumberController = TextEditingController();

  late final AppointmentUseCases _useCases;

  final String _activeRole = 'Staff';
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  AppointmentStatus? _statusFilter;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _selectedSessionType = 'Standard HD';

  @override
  void initState() {
    super.initState();
    _useCases = AppointmentUseCases(
      InMemoryAppointmentRepository(
        seedAppointments: [
          Appointment(
            id: 'seed-1',
            patientName: 'Rahul Verma',
            chairNumber: '2',
            scheduledAt: DateTime.now().add(const Duration(days: 1)).copyWith(
                  hour: 9,
                  minute: 0,
                ),
            sessionType: 'Standard HD',
          ),
          Appointment(
            id: 'seed-2',
            patientName: 'Asha Rani',
            chairNumber: '5',
            scheduledAt: DateTime.now().add(const Duration(days: 1)).copyWith(
                  hour: 12,
                  minute: 30,
                ),
            sessionType: 'High Flux',
            status: AppointmentStatus.checkedIn,
          ),
        ],
      ),
    );
    _loadAppointments();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _chairNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    final list = await _useCases.listAppointments();
    if (!mounted) return;

    setState(() {
      _appointments = list;
      _isLoading = false;
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _createAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final scheduledAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final error = await _useCases.createAppointment(
      patientName: _patientNameController.text.trim(),
      chairNumber: _chairNumberController.text.trim(),
      scheduledAt: scheduledAt,
      sessionType: _selectedSessionType,
    );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    _patientNameController.clear();
    _chairNumberController.clear();

    setState(() {
      _selectedSessionType = 'Standard HD';
    });

    await _loadAppointments();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dialysis session scheduled successfully.')),
    );
  }

  Future<void> _onStatusSelected(
    Appointment appointment,
    AppointmentStatus next,
  ) async {
    final error = await _useCases.updateAppointmentStatus(
      role: _activeRole,
      appointment: appointment,
      to: next,
    );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    await _loadAppointments();
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = target.difference(today).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.checkedIn:
        return 'Checked-in';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.missed:
        return 'Missed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return AppTheme.getStatusColor('scheduled');
      case AppointmentStatus.checkedIn:
        return AppTheme.getStatusColor('active');
      case AppointmentStatus.completed:
        return AppTheme.getStatusColor('completed');
      case AppointmentStatus.missed:
        return AppTheme.getStatusColor('error');
      case AppointmentStatus.cancelled:
        return AppTheme.getStatusColor('cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAppointments = _statusFilter == null
        ? _appointments
        : _appointments
            .where((appointment) => appointment.status == _statusFilter)
            .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Dialysis Scheduling')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book New Session',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.5.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _patientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient name',
                      hintText: 'Enter patient full name',
                    ),
                    validator: AppointmentValidator.validatePatientName,
                  ),
                  SizedBox(height: 1.5.h),
                  TextFormField(
                    controller: _chairNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Chair number',
                      hintText: 'e.g. 3',
                    ),
                    validator: AppointmentValidator.validateChairNumber,
                  ),
                  SizedBox(height: 1.5.h),
                  DropdownButtonFormField<String>(
                    value: _selectedSessionType,
                    decoration: const InputDecoration(labelText: 'Session type'),
                    items: const [
                      DropdownMenuItem(value: 'Standard HD', child: Text('Standard HD')),
                      DropdownMenuItem(value: 'High Flux', child: Text('High Flux')),
                      DropdownMenuItem(value: 'HDF', child: Text('HDF')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSessionType = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today_outlined),
                          label: Text(_formatDate(_selectedDate)),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(Icons.access_time_outlined),
                          label: Text(_selectedTime.format(context)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _createAppointment,
                      icon: const Icon(Icons.add_task),
                      label: const Text('Schedule Session'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Sessions',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButton<AppointmentStatus?>(
                  value: _statusFilter,
                  hint: const Text('Filter'),
                  items: [
                    const DropdownMenuItem<AppointmentStatus?>(
                      value: null,
                      child: Text('All'),
                    ),
                    ...AppointmentStatus.values.map(
                      (status) => DropdownMenuItem<AppointmentStatus?>(
                        value: status,
                        child: Text(_statusLabel(status)),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _statusFilter = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredAppointments.isEmpty)
              const Card(
                child: ListTile(
                  title: Text('No upcoming sessions'),
                  subtitle: Text('Create a schedule to see appointments here.'),
                ),
              )
            else
              ...filteredAppointments.map(
                (appointment) => Card(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppTheme.lightTheme.primaryColor.withValues(alpha: 0.15),
                      child: CustomIconWidget(
                        iconName: 'local_hospital',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    title: Text(appointment.patientName),
                    subtitle: Text(
                      '${_formatDate(appointment.scheduledAt)} • ${TimeOfDay.fromDateTime(appointment.scheduledAt).format(context)} • Chair ${appointment.chairNumber}\n${appointment.sessionType}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<AppointmentStatus>(
                      tooltip: 'Update status',
                      onSelected: (next) => _onStatusSelected(appointment, next),
                      itemBuilder: (context) => AppointmentStatus.values
                          .map(
                            (status) => PopupMenuItem<AppointmentStatus>(
                              value: status,
                              child: Text(_statusLabel(status)),
                            ),
                          )
                          .toList(),
                      child: Chip(
                        label: Text(_statusLabel(appointment.status)),
                        backgroundColor: _statusColor(appointment.status)
                            .withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
