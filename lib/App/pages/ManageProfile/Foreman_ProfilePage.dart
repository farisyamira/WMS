import 'package:flutter/material.dart';
import 'package:wms/App/Pages/ManageProfile/EditProfile.dart';
import 'package:wms/App/Pages/ManageProfile/ChangePassword.dart';
import 'package:wms/App/Pages/ManageProfile/DeleteProfile.dart';

class ForemanProfilePage extends StatelessWidget {
  final String foremanName;
  final String email;
  final String phone;
  final String skills;
  final String type;
  final double rating;

  const ForemanProfilePage({
    super.key,
    required this.foremanName,
    required this.email,
    required this.phone,
    required this.skills,
    required this.type,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foreman Profile"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.teal, width: 3),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              foremanName.toUpperCase(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {
    if (index < rating.floor()) {
      return const Icon(Icons.star, color: Colors.amber);
    } else if (index < rating && rating - index >= 0.5) {
      return const Icon(Icons.star_half, color: Colors.amber);
    } else {
      return const Icon(Icons.star_border, color: Colors.amber);
    }
  }),
),

            const SizedBox(height: 24),
            _infoCard(Icons.email, "Email Address", email),
            _infoCard(Icons.phone, "Phone Number", phone),
            _infoCard(Icons.build, "Foreman Type", type),
            _infoCard(Icons.handyman, "Skills", skills),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const DeleteProfilePage(),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text("Delete Profile"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
              icon: const Icon(Icons.lock_reset),
              label: const Text("Change Password"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(value, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
