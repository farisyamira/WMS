import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wms/App/Controller/scheduleController.dart';
import 'package:wms/App/Domain/ManageSchedule/schedule.model.dart';

class AddJobSchedulePage extends StatefulWidget {
  final Foreman foreman;

  const AddJobSchedulePage({super.key, required this.foreman});

  @override
  _AddJobSchedulePageState createState() => _AddJobSchedulePageState();
}

class _AddJobSchedulePageState extends State<AddJobSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _jobDescriptionController = TextEditingController();
  final _jobLocationController = TextEditingController();
  final _jobTypeController = TextEditingController();
  final _jobTimeController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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
        title: const Text('Add Job Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'For Foreman: ${widget.foreman.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _jobDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Job Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jobTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Job Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jobLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Job Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job location';
                    }
                    return null;
                  },
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
                        Text(
                          _selectedDate == null
                              ? 'Select date'
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        ),
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
                        Text(
                          _jobTimeController.text.isEmpty
                              ? 'Select time'
                              : _jobTimeController.text,
                        ),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _selectedDate != null &&
                          _jobTimeController.text.isNotEmpty) {
                        final newSchedule = JobSchedule(
                          jobScheduleId: '',
                          jobDescription: _jobDescriptionController.text,
                          jobDate: _selectedDate!,
                          jobTime: _jobTimeController.text,
                          jobStatus: 'Pending',
                          selectedForeman: widget.foreman.name,
                          jobLocation: _jobLocationController.text,
                          jobType: _jobTypeController.text,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          deletedAt: null,
                          foremanId: widget.foreman.foremanId,
                          workshopOwnerId: widget.foreman.workshopOwnerId,
                        );

                        try {
                          await Provider.of<ScheduleController>(context, listen: false)
                              .addJobSchedule(newSchedule, widget.foreman.workshopOwnerId);
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all fields')),
                        );
                      }
                    },
                    child: const Text('Create Schedule'),
                  ),
                ),
              ],
            ),
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