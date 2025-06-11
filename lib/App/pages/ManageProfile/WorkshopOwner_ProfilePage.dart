// 1. WorkshopOwner_ProfilePage.dart
import 'package:flutter/material.dart';

class WorkshopOwnerProfilePage extends StatelessWidget {
  final String ownerName;
  final String email;
  final String phone;
  final String workshopName;
  final String location;

  const WorkshopOwnerProfilePage({
    super.key,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.workshopName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshop Owner Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editWorkshopOwnerProfile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileField('Name', ownerName),
                _profileField('Email', email),
                _profileField('Phone', phone),
                _profileField('Workshop Name', workshopName),
                _profileField('Location', location),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}