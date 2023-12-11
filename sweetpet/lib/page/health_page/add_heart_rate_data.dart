import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// [AddHeartRateDataPage] facilitates the input of heart rate data by the user.
/// This page provides text fields to input heart rate in beats per minute (BPM),
/// along with the date and time of the measurement.
class AddHeartRateDataPage extends StatefulWidget {
  @override
  _AddHeartRateDataPageState createState() => _AddHeartRateDataPageState();
}

/// State class for [AddHeartRateDataPage] that manages the input fields
/// and handles the data submission process.
class _AddHeartRateDataPageState extends State<AddHeartRateDataPage> {
  // Controllers for managing the content of each text field.
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _bpmController = TextEditingController();

  // Variables to hold the current selected date and time for the heart rate measurement.
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  /// Asynchronously triggers the date picker dialog and updates the date input field
  /// with the selected date formatted in a user-friendly format.
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMMMMd().format(pickedDate);
      });
    }
  }

  /// Asynchronously triggers the time picker dialog and updates the time input field
  /// with the selected time.
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  /// Checks if all the form fields have been filled out by the user.
  bool _isFormFilled() {
    return _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _bpmController.text.isNotEmpty;
  }

  /// Handles the submission of the entered data. It performs validation to ensure
  /// that all fields have data before proceeding with the submission logic.
  void _submitData() {
    if (!_isFormFilled()) return;
    // TODO: Add the data submission logic, such as saving to a database or sending to a server.

    Navigator.pop(
        context); // Navigates back to the previous page after data submission.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Heart Rate Data'),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () =>
              Navigator.pop(context), // Allows user to cancel the operation.
        ),
        actions: [
          // Button to trigger the submission of the heart rate data.
          TextButton(
            onPressed: _isFormFilled() ? _submitData : null,
            child: Text(
              'Add',
              style:
                  TextStyle(color: _isFormFilled() ? Colors.blue : Colors.grey),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Date input field with a calendar date picker.
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            // Time input field with a clock time picker.
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _pickTime(context),
            ),
            // Heart rate input field accepting numerical BPM values.
            TextField(
              controller: _bpmController,
              decoration: InputDecoration(
                labelText: 'Heart Rate (BPM)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }
}
