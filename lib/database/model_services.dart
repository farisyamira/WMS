class ModelServices {
  // Mock data storage
  final List<Map<String, dynamic>> _mockForemen = [ {
      'id': '1',
      'name': 'John Wick',
      'workshopOwner_id': 'WO22110',
      'status': 'Active'
    },
    {
      'id': '2',
      'name': 'Robin Ahmad',
      'workshopOwner_id': 'WO22110',
      'status': 'Active'
    },
    {
      'id': '3',
      'name': 'Zakafa Zabi',
      'workshopOwner_id': 'WO22110',
      'status': 'Active'
    },
    {
      'id': '4',
      'name': 'Jack Rey',
      'workshopOwner_id': 'WO22110',
      'status': 'Active'
    },
    ];
  final List<Map<String, dynamic>> _mockJobSchedules = [];

  // Foreman Services
  Future<void> addForeman(Map<String, dynamic> foremanData) async {
    _mockForemen.add(foremanData);
  }

  Future<List<Map<String, dynamic>>> getForemen(String workshopOwnerId) async {
    return _mockForemen.where((foreman) => foreman['workshopOwner_id'] == workshopOwnerId).toList();
  }

  // Job Schedule Services
  Future<void> addJobSchedule(Map<String, dynamic> scheduleData) async {
    _mockJobSchedules.add(scheduleData);
  }

  Future<List<Map<String, dynamic>>> getJobSchedules(String workshopOwnerId) async {
    return _mockJobSchedules.where((schedule) => schedule['workshopOwnerId'] == workshopOwnerId).toList();
  }

  Future<void> updateJobSchedule(String scheduleId, Map<String, dynamic> updateData) async {
    final index = _mockJobSchedules.indexWhere((schedule) => schedule['id'] == scheduleId);
    if (index != -1) {
      _mockJobSchedules[index] = {..._mockJobSchedules[index], ...updateData};
    }
  }

  Future<void> deleteJobSchedule(String scheduleId) async {
    _mockJobSchedules.removeWhere((schedule) => schedule['id'] == scheduleId);
  }

  // Additional methods as needed
  Future<Map<String, dynamic>?> getForemanById(String foremanId) async {
    return _mockForemen.firstWhere((foreman) => foreman['id'] == foremanId);
  }
}