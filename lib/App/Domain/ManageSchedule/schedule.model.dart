import 'package:cloud_firestore/cloud_firestore.dart';

class Foreman {
  final String foremanId;
  final String name;
  final String phoneNum;
  final String email;
  final String status;
  final String accountNum;
  final String accountBank;
  final double rating;
  final String type;
  final String username;
  final String password;
  final String workshopOwnerId;

  Foreman({
    required this.foremanId,
    required this.name,
    required this.phoneNum,
    required this.email,
    required this.status,
    required this.accountNum,
    required this.accountBank,
    required this.rating,
    required this.type,
    required this.username,
    required this.password,
    required this.workshopOwnerId,
  });

  factory Foreman.fromMap(Map<String, dynamic> data) {
    return Foreman(
      foremanId: data['foremanId'] ?? '',
      name: data['foreman_name'] ?? '',
      phoneNum: data['foreman_phoneNum'] ?? '',
      email: data['foreman_email'] ?? '',
      status: data['foreman_status'] ?? 'Available',
      accountNum: data['foreman_accountNum'] ?? '',
      accountBank: data['foreman_accountBank'] ?? '',
      rating: (data['foreman_rating'] ?? 0.0).toDouble(),
      type: data['foreman_type'] ?? 'Full-time',
      username: data['foreman_username'] ?? '',
      password: data['foreman_password'] ?? '',
      workshopOwnerId: data['workshopOwner_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foreman_name': name,
      'foreman_phoneNum': phoneNum,
      'foreman_email': email,
      'foreman_status': status,
      'foreman_accountNum': accountNum,
      'foreman_accountBank': accountBank,
      'foreman_rating': rating,
      'foreman_type': type,
      'foreman_username': username,
      'foreman_password': password,
      'workshopOwner_id': workshopOwnerId,
    };
  }
}

class JobSchedule {
  final String jobScheduleId;
  final String jobDescription;
  final DateTime jobDate;
  final String jobTime;
  String jobStatus;
  final String selectedForeman;
  final String jobLocation;
  final String jobType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String foremanId;
  final String workshopOwnerId;

  JobSchedule({
    required this.jobScheduleId,
    required this.jobDescription,
    required this.jobDate,
    required this.jobTime,
    required this.jobStatus,
    required this.selectedForeman,
    required this.jobLocation,
    required this.jobType,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.foremanId,
    required this.workshopOwnerId,
  });

  factory JobSchedule.fromMap(Map<String, dynamic> data) {
    return JobSchedule(
      jobScheduleId: data['jobScheduleId'] ?? '',
      jobDescription: data['jobDescription'] ?? '',
      jobDate: data['jobDate'] is Timestamp 
          ? (data['jobDate'] as Timestamp).toDate()
          : DateTime.now(),
      jobTime: data['jobTime'] ?? '',
      jobStatus: data['jobStatus'] ?? 'Pending',
      selectedForeman: data['selectedForeman'] ?? '',
      jobLocation: data['jobLocation'] ?? '',
      jobType: data['jobType'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      deletedAt: data['deletedAt'] != null 
          ? (data['deletedAt'] is Timestamp
              ? (data['deletedAt'] as Timestamp).toDate()
              : null)
          : null,
      foremanId: data['foremanId'] ?? '',
      workshopOwnerId: data['workshopOwnerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobDescription': jobDescription,
      'jobDate': jobDate,
      'jobTime': jobTime,
      'jobStatus': jobStatus,
      'selectedForeman': selectedForeman,
      'jobLocation': jobLocation,
      'jobType': jobType,
      'foremanId': foremanId,
      'workshopOwnerId': workshopOwnerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}