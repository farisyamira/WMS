import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate list of search keywords
  List<String> _generateKeywords(String input) {
    input = input.toLowerCase();
    List<String> result = [];
    for (int i = 1; i <= input.length; i++) {
      result.add(input.substring(0, i));
    }
    return result;
  }

  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? workshopName,
    String? location,
    String? operatingHours,
    String? workshopDetails,
    List<String>? skills,
    String? type,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final usernameKeywords = _generateKeywords(username);
      final emailKeywords = _generateKeywords(email.split('@').first);

      final data = {
        'uid': uid,
        'username': username,
        'email': email,
        'role': role,
        'phone': phone ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'keywords': [...usernameKeywords, ...emailKeywords],
      };

      if (role == 'Workshop Owner') {
        data.addAll({
          'workshopName': workshopName ?? '',
          'location': location ?? '',
          'operatingHours': operatingHours ?? '',
          'workshopDetails': workshopDetails ?? '',
        });
      } else if (role == 'Foreman') {
        data.addAll({
          'skills': skills ?? [],
          'type': type ?? '',
          'rating': 0.0,
        });
      }

      await _firestore.collection('users').doc(uid).set(data);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred.";
    }
  }
}
