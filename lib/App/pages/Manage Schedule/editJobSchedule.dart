import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wms/App/Controller/scheduleController.dart';
import 'package:wms/App/Domain/ManageSchedule/schedule.model.dart';

class EditJobSchedulePage extends StatefulWidget {
  final JobSchedule schedule;
  final String workshopOwnerId;

  const EditJobSchedulePage({
    super.key,
    required this.schedule,
    required this.workshopOwnerId,
  });

  @override
  _EditJobSchedulePageState createState() => _EditJobSchedulePageState();
}

class _EditJobSchedulePageState extends State<EditJobSchedulePage> {
  late TextEditingController _jobDescriptionController;
  late TextEditingController _jobLocationController;
  late TextEditingController _jobTypeController;
  late TextEditingController _jobTimeController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _jobDescriptionController = TextEditingController(text: widget.schedule.jobDescription);
    _jobLocationController = TextEditingController(text: widget.schedule.jobLocation);
    _jobTypeController = TextEditingController(text: widget.schedule.jobType);
    _jobTimeController = TextEditingController(text: widget.schedule.jobTime);
    _selectedDate = widget.schedule.jobDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.parse('2023-01-01 ${widget.schedule.jobTime}')),
    );
    if (picked != null) {
      setState(() {
        _jobTimeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Job Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For Foreman: ${widget.schedule.selectedForeman}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _jobDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jobTypeController,
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jobLocationController,
                decoration: const InputDecoration(
                  labelText: 'Job Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Job Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Job Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_jobTimeController.text),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedSchedule = JobSchedule(
                        jobScheduleId: widget.schedule.jobScheduleId,
                        jobDescription: _jobDescriptionController.text,
                        jobDate: _selectedDate,
                        jobTime: _jobTimeController.text,
                        jobStatus: widget.schedule.jobStatus,
                        selectedForeman: widget.schedule.selectedForeman,
                        jobLocation: _jobLocationController.text,
                        jobType: _jobTypeController.text,
                        createdAt: widget.schedule.createdAt,
                        updatedAt: DateTime.now(),
                        deletedAt: widget.schedule.deletedAt,
                        foremanId: widget.schedule.foremanId,
                        workshopOwnerId: widget.schedule.workshopOwnerId,
                      );

                      try {
                        await Provider.of<ScheduleController>(context, listen: false)
                            .updateJobSchedule(
                              widget.schedule.jobScheduleId,
                              updatedSchedule.toMap(),
                            );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    _jobLocationController.dispose();
    _jobTypeController.dispose();
    _jobTimeController.dispose();
    super.dispose();
  }
}