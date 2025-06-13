import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate list of search keywords
  List<String> generateKeywords(Map<String, dynamic> userData) {
    final keywords = <String>[];

    void addKeyword(String? value) {
      if (value != null && value.isNotEmpty) {
        keywords.addAll(value.toLowerCase().split(' '));
      }
    }

    addKeyword(userData['username']);
    addKeyword(userData['email']);
    addKeyword(userData['type']); // for Foreman

    return keywords.toSet().toList(); // remove duplicates
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

      final userData = {
        'username': username,
        'email': email,
        'type': type ?? '',
      };

      final keywords = generateKeywords(userData);

      final data = {
        'uid': uid,
        'username': username,
        'email': email,
        'role': role,
        'phone': phone ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'keywords': keywords,
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
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred: $e";
    }
  }
}
