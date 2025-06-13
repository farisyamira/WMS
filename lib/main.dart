// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms/App/Controller/scheduleController.dart';
import 'package:wms/App/pages/Manage Schedule/scheduleManagement.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduleController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // You need to provide a workshopOwnerId here
      home: const ScheduleManagementPage(workshopOwnerId: 'WO22110'),
    );
  }
}