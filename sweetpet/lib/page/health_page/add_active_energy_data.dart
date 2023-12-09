import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddActiveEnergyDataPage extends StatefulWidget {
  @override
  _AddActiveEnergyDataPageState createState() =>
      _AddActiveEnergyDataPageState();
}

class _AddActiveEnergyDataPageState extends State<AddActiveEnergyDataPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _caloriesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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

  bool _isFormFilled() {
    return _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _caloriesController.text.isNotEmpty;
  }

  void _submitData() {
    if (!_isFormFilled()) return;

    // TODO: Implement your data submission logic here.
    // This could involve sending data to a backend service,
    // saving it to a local database, or even just updating state within the app.

    // After data submission logic is executed, navigate back to the ActiveEnergyPage.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Energy'),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
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
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDate(context),
            ),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _pickTime(context),
            ),
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
