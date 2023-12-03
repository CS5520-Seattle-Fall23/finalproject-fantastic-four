import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SummaryPage(),
    );
  }
}

class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: _pickImage,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.flash_on),
            title: Text('Active Energy'),
            trailing: Text('122 cal'),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Heart Rate'),
            trailing: Text('No Data'),
          ),
          ListTile(
            leading: Icon(Icons.hotel),
            title: Text('Sleep'),
            trailing: Text('6 hr 4 min'),
          ),
          ListTile(
            leading: Icon(Icons.accessibility_new),
            title: Text('Stand Hours'),
            trailing: Text('No Data'),
          ),
          ListTile(
            leading: Icon(Icons.directions_walk),
            title: Text('Steps'),
            trailing: Text('4,254 steps'),
          ),
          ListTile(
            leading: Icon(Icons.transfer_within_a_station),
            title: Text('Walking Asymmetry'),
            trailing: Text('3.6%'),
          ),
        ],
      ),
    );
  }
}
