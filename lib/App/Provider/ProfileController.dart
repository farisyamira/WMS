import 'package:cloud_firestore/cloud_firestore.dart';
import '../Domain/ManageProfileModel/ProfileModel.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Failed to fetch user profile: $e');
      return null;
    }
  }
}
