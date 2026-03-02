class MockPatientDetailDataSource {
  Map<String, dynamic> fetchPatientDetail(String patientId) => {
        'patientData': {
          'id': 'P001',
          'name': 'Rajesh Kumar',
          'uhid': 'UH2024001',
          'age': 58,
          'gender': 'Male',
          'avatar':
              'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400',
          'currentStatus': 'active',
          'tmsId': 'TMS2024001',
          'phone': '+91 9876543210',
          'email': 'rajesh.kumar@email.com',
        },
        'medicalHistory': [
          {
            'id': 'H001',
            'cycleType': 'Hemodialysis',
            'diagnosis': 'Chronic Kidney Disease Stage 5',
            'status': 'completed',
            'completedSessions': 36,
            'totalSessions': 36,
          }
        ],
        'currentCycle': {
          'id': 'C003',
          'cycleType': 'Hemodialysis',
          'status': 'active',
          'sessions': [
            {
              'id': 'S001',
              'sessionNumber': 1,
              'status': 'completed',
              'scheduledDate': '01/09/2024',
              'duration': '4 hours'
            }
          ]
        },
        'documents': [
          {
            'id': 'D001',
            'fileName': 'Lab_Report_Sept_2024.pdf',
            'category': 'Lab Reports',
            'uploadDate': '2024-09-05',
            'fileSize': '2.5 MB',
            'thumbnailUrl': null
          }
        ],
        'vitalsData': [
          {
            'id': 'V001',
            'type': 'Blood Pressure',
            'value': '120/80',
            'unit': 'mmHg',
            'timestamp': '2024-09-08T10:30:00Z',
            'status': 'normal'
          }
        ]
      };
}
