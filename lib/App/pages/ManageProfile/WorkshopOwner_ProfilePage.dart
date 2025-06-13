import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wms/App/Pages/ManageProfile/EditProfile.dart';
import 'package:wms/App/Pages/ManageProfile/ChangePassword.dart';
import 'package:wms/App/Pages/ManageProfile/DeleteProfile.dart';

class WorkshopOwnerProfilePage extends StatefulWidget {
  final String ownerName;
  final String email;
  final String phone;
  final String workshopName;
  final String location;
  final String operatingHours;
  final String workshopDetails;
  final bool isMe;

  const WorkshopOwnerProfilePage({
    super.key,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.workshopName,
    required this.location,
    required this.operatingHours,
    required this.workshopDetails,
    this.isMe = true, // default is true
  });

  @override
  State<WorkshopOwnerProfilePage> createState() => _WorkshopOwnerProfilePageState();
}

class _WorkshopOwnerProfilePageState extends State<WorkshopOwnerProfilePage> {
  late String ownerName;
  late String email;
  late String phone;
  late String workshopName;
  late String location;
  late String operatingHours;
  late String workshopDetails;
  late bool isMe;

  @override
  void initState() {
    super.initState();
    ownerName = widget.ownerName;
    email = widget.email;
    phone = widget.phone;
    workshopName = widget.workshopName;
    location = widget.location;
    operatingHours = widget.operatingHours;
    workshopDetails = widget.workshopDetails;
    isMe = widget.isMe;
  }

  Future<void> _reloadProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        ownerName = data['username'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        workshopName = data['workshopName'] ?? '';
        location = data['location'] ?? '';
        operatingHours = data['operatingHours'] ?? '';
        workshopDetails = data['workshopDetails'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workshop Owner Profile"),
        backgroundColor: const Color(0xFF448AFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF448AFF), width: 3),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ownerName.toUpperCase(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _infoCard(Icons.email, "Email Address", email),
            _infoCard(Icons.phone, "Phone Number", phone),
            _infoCard(Icons.business, "Workshop Name", workshopName),
            _infoCard(Icons.location_on, "Location", location),
            _infoCard(Icons.access_time, "Operating Hours", operatingHours),
            _infoCard(Icons.info_outline, "Workshop Detail", workshopDetails),
            const SizedBox(height: 30),

            // Only show these buttons if this is the current user's profile
            if (isMe) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                  await _reloadProfile(); // Reload after editing
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF448AFF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
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
        leading: Icon(icon, color: const Color(0xFF448AFF)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
