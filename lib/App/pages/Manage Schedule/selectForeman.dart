import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageSchedule/schedule.model.dart';
import 'package:wms/App/pages/Manage Schedule/addJobSchedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectForemanPage extends StatelessWidget {
  final Foreman foreman;

  const SelectForemanPage({super.key, required this.foreman});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(foreman.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foreman.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Phone: ${foreman.phoneNum}'),
                    Text('Email: ${foreman.email}'),
                    Text('Status: ${foreman.status}'),
                    Text('Rating: ${foreman.rating.toStringAsFixed(1)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Job Schedule'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddJobSchedulePage(foreman: foreman),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
