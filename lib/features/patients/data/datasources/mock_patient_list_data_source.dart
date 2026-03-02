class MockPatientListDataSource {
  List<Map<String, dynamic>> fetchPatients() => [
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
      ];

  List<Map<String, dynamic>> fetchFilters() => [
        {'key': 'active', 'label': 'Active Cycles', 'count': 2},
        {'key': 'pending', 'label': 'Pending Approval', 'count': 1},
        {'key': 'in_session', 'label': 'In Session', 'count': 1},
      ];
}
