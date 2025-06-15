import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:wms/App/Controller/scheduleController.dart';
import 'package:wms/App/Domain/ManageSchedule/schedule.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptJobPage extends StatelessWidget {
  final JobSchedule schedule;

  const AcceptJobPage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You have been assigned a new job:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.jobDescription,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Type: ${schedule.jobType}'),
                    Text('Location: ${schedule.jobLocation}'),
                    Text(
                      'Date: ${DateFormat('MMMM d, yyyy').format(schedule.jobDate)}',
                    ),
                    Text('Time: ${schedule.jobTime}'),
                    Text('Status: ${schedule.jobStatus}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Do you accept this job assignment?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Provider.of<ScheduleController>(
                      context,
                      listen: false,
                    ).updateJobStatus(schedule.jobScheduleId, 'Rejected');
                    Navigator.pop(context);
                  },
                  child: const Text('Reject'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Provider.of<ScheduleController>(
                      context,
                      listen: false,
                    ).updateJobStatus(schedule.jobScheduleId, 'Accepted');
                    Navigator.pop(context);
                  },
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
