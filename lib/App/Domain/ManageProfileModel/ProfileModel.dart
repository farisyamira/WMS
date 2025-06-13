import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String username;
  final String email;
  final String role;
  final String? phone;
  final List<String>? skills;           // For Foreman
  final String? type;                   // For Foreman
  final String? workshopName;          // For Workshop Owner
  final String? location;              // For Workshop Owner
  final String? operatingHours;        // For Workshop Owner
  final String? workshopDetails;        // For Workshop Owner
  final DateTime? createdAt;

  UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    required this.role,
    this.phone,
    this.skills,
    this.type,
    this.workshopName,
    this.location,
    this.operatingHours,
    this.workshopDetails,
    this.createdAt,
  });

  /// Convert Firestore map to `UserProfile` object
  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      phone: map['phone'],
      skills: (map['skills'] as List?)?.map((e) => e.toString()).toList(),
      type: map['type'],
      workshopName: map['workshopName'],
      location: map['location'],
      operatingHours: map['operatingHours'],
      workshopDetails: map['workshopDetails'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert `UserProfile` object to Firestore map
  Map<String, dynamic> toMap() {
    final map = {
      'username': username,
      'email': email,
      'role': role,
      'phone': phone,
      'skills': skills,
      'type': type,
      'workshopName': workshopName,
      'location': location,
      'operatingHours': operatingHours,
      'workshopDetails': workshopDetails,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Remove null values so they don't overwrite existing fields with null in Firestore
    map.removeWhere((key, value) => value == null);
    return map;
  }
}