import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms/App/Controller/scheduleController.dart';
import 'package:wms/App/pages/Manage Schedule/selectForeman.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleManagementPage extends StatefulWidget {
  final String workshopOwnerId;

  const ScheduleManagementPage({super.key, required this.workshopOwnerId});

  @override
  _ScheduleManagementPageState createState() => _ScheduleManagementPageState();
}

class _ScheduleManagementPageState extends State<ScheduleManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleController>(
        context,
        listen: false,
      ).loadForemen(widget.workshopOwnerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ScheduleController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Schedule - List of Foremen')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Schedule Management',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: controller.foremen.length,
                    itemBuilder: (context, index) {
                      final foreman = controller.foremen[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${foreman.name}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SelectForemanPage(foreman: foreman),
                                    ),
                                  );
                                },
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
