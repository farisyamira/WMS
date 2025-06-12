import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wms/App/Provider/ProfileController.dart';
import 'package:wms/App/Pages/ManageProfile/LoginPage.dart';

class DeleteProfilePage extends StatelessWidget {
  const DeleteProfilePage({super.key});

  void _deleteAccount(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final profileController = ProfileController();

    // Delete Firestore profile
    await profileController.deleteProfile(userId);

    // Delete Firebase Auth account
    await FirebaseAuth.instance.currentUser!.delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile deleted')));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Profile"),
      content: const Text("Are you sure you want to delete your profile? This action is irreversible."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () => _deleteAccount(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
