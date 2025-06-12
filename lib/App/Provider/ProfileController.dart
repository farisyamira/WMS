import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateProfile({
    required String userId,
    required String username,
    required String email,
    required String phone,
    required List<String> skills,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'username': username,
      'email': email,
      'phone': phone,
      'skills': skills,
    });
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  Future<void> deleteProfile(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
