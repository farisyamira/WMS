import 'package:flutter/material.dart';

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
        title: const Text('Foreman Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editForemanProfile');
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
                _profileField('Name', foremanName),
                _profileField('Email', email),
                _profileField('Phone', phone),
                _profileField('Skills', skills),
                _profileField('Type', type),
                _profileField('Rating', rating.toStringAsFixed(1)),
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
