import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDataPage extends StatefulWidget {
  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController calController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeController.text = picked.format(context);
      });
    }
  }

  bool get isAddButtonEnabled {
    return dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        calController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Active Energy Data'),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: isAddButtonEnabled
                ? () {
                    // Implement data addition logic
                  }
                : null,
            child: Text(
              'Add',
              style: TextStyle(
                color: isAddButtonEnabled ? Colors.blue : Colors.grey,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
              readOnly: true,
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                suffixIcon: Icon(Icons.access_time),
              ),
              onTap: () => _selectTime(context),
              readOnly: true,
            ),
            TextField(
              controller: calController,
              decoration: InputDecoration(
                labelText: 'Calories (cal)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  // Trigger button state update
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
