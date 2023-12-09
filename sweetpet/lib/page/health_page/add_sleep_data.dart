import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSleepDataPage extends StatefulWidget {
  @override
  _AddSleepDataPageState createState() => _AddSleepDataPageState();
}

class _AddSleepDataPageState extends State<AddSleepDataPage> {
  DateTime _selectedInBed = DateTime.now();
  DateTime _selectedAsleep = DateTime.now();
  DateTime _selectedAwake = DateTime.now();
  DateTime _selectedREM = DateTime.now();
  DateTime _selectedCore = DateTime.now();
  DateTime _selectedDeep = DateTime.now();

  Future<void> _selectDateTime(BuildContext context, DateTime initialDate,
      Function(DateTime) onSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null) return;

    final DateTime selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() => onSelected(selectedDateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sleep Data'),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.of(context).pop(), // Return to SleepPage
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Add logic to store the sleep data
              Navigator.of(context)
                  .pop(); // Return to SleepPage after adding data
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // In Bed
          ListTile(
            title: Text('In Bed'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_selectedInBed)),
            onTap: () => _selectDateTime(
                context, _selectedInBed, (value) => _selectedInBed = value),
          ),
          // Asleep
          ListTile(
            title: Text('Asleep'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_selectedAsleep)),
            onTap: () => _selectDateTime(
                context, _selectedAsleep, (value) => _selectedAsleep = value),
          ),
          // Awake
          ListTile(
            title: Text('Awake'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_selectedAwake)),
            onTap: () => _selectDateTime(
                context, _selectedAwake, (value) => _selectedAwake = value),
          ),
          // REM
          ListTile(
            title: Text('REM'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_selectedREM)),
            onTap: () => _selectDateTime(
                context, _selectedREM, (value) => _selectedREM = value),
          ),
          // Core
          ListTile(
            title: Text('Core'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_selectedCore)),
            onTap: () => _selectDateTime(
                context, _selectedCore, (value) => _selectedCore = value),
          ),
          // Deep
          ListTile(
            title: Text('Deep'),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_selectedDeep)),
            onTap: () => _selectDateTime(
                context, _selectedDeep, (value) => _selectedDeep = value),
          ),
        ],
      ),
    );
  }
}
