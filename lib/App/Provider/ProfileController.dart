import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Update the user profile based on their role and fields provided
  Future<void> updateProfile({
    required String userId,
    required String username,
    required String email,
    required String phone,
    String? role,
    List<String>? skills,            // Foreman
    String? type,                    // Foreman
    String? workshopName,           // Workshop Owner
    String? location,               // Workshop Owner
    String? operatingHours,         // Workshop Owner
    String? workshopDetails,         // Workshop Owner
  }) async {
    final Map<String, dynamic> updatedData = {
      'username': username,
      'email': email,
      'phone': phone,
    };

    // Add role-specific data
    if (role == 'Foreman') {
      updatedData['skills'] = skills ?? [];
      updatedData['type'] = type ?? '';
    } else if (role == 'Workshop Owner') {
      updatedData['workshopName'] = workshopName ?? '';
      updatedData['location'] = location ?? '';
      updatedData['operatingHours'] = operatingHours ?? '';
      updatedData['workshopDetails'] = workshopDetails ?? '';
    }

    await _firestore.collection('users').doc(userId).update(updatedData);
  }

  /// Fetch user profile by UID
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  /// Delete the user profile
  Future<void> deleteProfile(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
