import 'package:flutter/material.dart';
import 'package:wms/App/Domain/ManageSchedule/schedule.model.dart';
import 'package:wms/database/model_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Uses ChangeNotifier to notify listeners when data changes
class ScheduleController with ChangeNotifier {
  // Service class that handles database operations
  final ModelServices _modelServices = ModelServices();

  // Private lists to store foremen and job schedules
  List<Foreman> _foremen = [];
  List<JobSchedule> _jobSchedules = [];

  // Loading state flag
  bool _isLoading = false;

  // Getters to expose private data to the UI
  List<Foreman> get foremen => _foremen;
  List<JobSchedule> get jobSchedules => _jobSchedules;
  bool get isLoading => _isLoading;

  Future<void> loadForemen(String workshopOwnerId) async {
    // Set loading state to true and notify listeners
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch foremen data from the database
      final foremenData = await _modelServices.getForemen(workshopOwnerId);

      // Convert raw data to Foreman objects and update the list
      _foremen = foremenData.map((data) => Foreman.fromMap(data)).toList();
    } catch (e) {
      // Log any errors that occur during loading
      debugPrint('Error loading foremen: $e');
    } finally {
      // Regardless of success or failure, set loading to false and notify
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadJobSchedules(String workshopOwnerId) async {
    // Set loading state to true and notify listeners
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch schedules data from the database
      final schedulesData = await _modelServices.getJobSchedules(
        workshopOwnerId,
      );

      // Convert raw data to JobSchedule objects and update the list
      _jobSchedules = schedulesData
          .map((data) => JobSchedule.fromMap(data))
          .toList();
    } catch (e) {
      // Log any errors that occur during loading
      debugPrint('Error loading job schedules: $e');
    } finally {
      // Regardless of success or failure, set loading to false and notify
      _isLoading = false;
      notifyListeners();
    }
  }

  // add job schedule
  Future<void> addJobSchedule(
    JobSchedule schedule,
    String workshopOwnerId,
  ) async {
    try {
      // Add the schedule to database by converting it to a map
      await _modelServices.addJobSchedule(schedule.toMap());

      // Refresh the schedules list to include the new addition
      await loadJobSchedules(workshopOwnerId);
    } catch (e) {
      // Log and rethrow any errors for the UI to handle
      debugPrint('Error adding job schedule: $e');
      rethrow;
    }
  }

  // Updates the status of a job schedule
  Future<void> updateJobStatus(String scheduleId, String status) async {
    try {
      // Update the status in the database
      await _modelServices.updateJobSchedule(scheduleId, {'jobStatus': status});

      // Find and update the corresponding schedule in the local list
      final index = _jobSchedules.indexWhere(
        (s) => s.jobScheduleId == scheduleId,
      );
      if (index != -1) {
        _jobSchedules[index].jobStatus = status;
        notifyListeners(); // Notify UI of the change
      }
    } catch (e) {
      // Log and rethrow any errors for the UI to handle
      debugPrint('Error updating job status: $e');
      rethrow;
    }
  }

  // Deletes a job schedule from the database
  Future<void> deleteJobSchedule(
    String scheduleId,
    String workshopOwnerId,
  ) async {
    try {
      // Delete the schedule from the database
      await _modelServices.deleteJobSchedule(scheduleId);

      // Refresh the schedules list to reflect the deletion
      await loadJobSchedules(workshopOwnerId);
    } catch (e) {
      // Log and rethrow any errors for the UI to handle
      debugPrint('Error deleting job schedule: $e');
      rethrow;
    }
  }
}
