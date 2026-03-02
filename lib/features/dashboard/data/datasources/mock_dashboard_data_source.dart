class MockDashboardDataSource {
  Map<String, dynamic> fetchCurrentUser() => {
        'id': 1,
        'name': 'Dr. Priya Sharma',
        'role': 'RMO',
        'center': 'Apollo Dialysis Center, Mumbai',
      };

  Map<String, List<Map<String, dynamic>>> fetchRoleBasedCards() => {
        'RMO': [
          {
            'title': 'Pending Clinical Notes',
            'subtitle': 'Awaiting your review and approval',
            'count': '12',
            'priority': 'Urgent',
            'icon': 'assignment_late',
          }
        ],
      };
}
