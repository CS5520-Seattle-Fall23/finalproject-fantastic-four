import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// [AddActiveEnergyDataPage] provides a user interface for adding active energy data.
/// It includes fields for date, time, and calories burned, which the user can fill to record their activity.
class AddActiveEnergyDataPage extends StatefulWidget {
  @override
  _AddActiveEnergyDataPageState createState() =>
      _AddActiveEnergyDataPageState();
}

/// State class for [AddActiveEnergyDataPage].
/// Manages the input fields and data submission process.
class _AddActiveEnergyDataPageState extends State<AddActiveEnergyDataPage> {
  // Controllers to manage text field inputs.
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _caloriesController = TextEditingController();

  // Variables to hold the selected date and time.
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  /// Asynchronously opens a date picker for the user to select a date.
  /// Once a date is selected, updates the state and the date input field.
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

  /// Asynchronously opens a time picker for the user to select a time.
  /// Once a time is selected, updates the state and the time input field.
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

  /// Validates if all form fields are filled out.
  bool _isFormFilled() {
    return _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _caloriesController.text.isNotEmpty;
  }

  /// Submits the active energy data if the form is fully filled out.
  /// Placeholder for actual data submission logic.
  void _submitData() {
    if (!_isFormFilled()) return;
    // Implement the data submission logic.
    // This could include API calls to backend services or database interactions.

    Navigator.pop(context); // Returns to the previous screen after submission.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Energy'),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.pop(
              context), // Allows the user to cancel the operation.
        ),
        actions: [
          // Button to submit the form if all fields are filled.
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
          children: <Widget>[
            // Field for selecting the date.
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            // Field for selecting the time.
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _pickTime(context),
            ),
            // Field for inputting calories.
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(
                labelText: 'Calories (cal)',
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
