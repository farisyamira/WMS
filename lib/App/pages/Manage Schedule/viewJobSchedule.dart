import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms/App/Domain/ManageSchedule/schedule.model.dart';

class ViewJobSchedulePage extends StatelessWidget {
  final List<JobSchedule> schedules;

  const ViewJobSchedulePage({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Job Schedules'),
      ),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(schedule.jobDescription),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${schedule.jobType}'),
                  Text('Location: ${schedule.jobLocation}'),
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(schedule.jobDate)}'),
                  Text('Time: ${schedule.jobTime}'),
                  Text(
                    'Status: ${schedule.jobStatus}',
                    style: TextStyle(
                      color: schedule.jobStatus == 'Accepted'
                          ? Colors.green
                          : schedule.jobStatus == 'Rejected'
                              ? Colors.red
                              : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: schedule.jobStatus == 'Pending'
                  ? IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AcceptJobPage(schedule: schedule),
                          ),
                        );
                      },
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}