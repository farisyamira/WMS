import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms/App/Controller/scheduleController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteJobSchedulePage extends StatelessWidget {
  final String scheduleId;
  final String workshopOwnerId;

  const DeleteJobSchedulePage({
    super.key,
    required this.scheduleId,
    required this.workshopOwnerId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this job schedule?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await Provider.of<ScheduleController>(
                context,
                listen: false,
              ).deleteJobSchedule(scheduleId, workshopOwnerId);
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
