import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Import the detailed pages for navigation.
import 'active_energy.dart';
import 'heart_rate.dart';
import 'sleep.dart';
import 'stand_hours.dart';


/// SummaryPage provides an overview of the user's health metrics.
///
/// This screen shows a list of health-related metrics, such as Active Energy,
/// Heart Rate, Sleep, Stand Hours, Steps, and Walking Asymmetry. Each metric
/// is displayed with a leading icon, the metric's name, the current value,
/// and a trailing arrow icon. Tapping on the metric navigates to a detailed
/// page where the user can view more data and make updates.
class SummaryPage extends StatefulWidget {
  @override
  _SummaryPageState createState() => _SummaryPageState();
}

/// The state for SummaryPage.
///
/// Manages the user's profile image and handles the navigation to detail pages for
/// each health metric. Users can update their profile picture via an image picker.
class _SummaryPageState extends State<SummaryPage> {
  XFile? _image;

  /// Opens an image picker for the user to select a new profile picture.
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  /// Navigates to a detailed page for a specific health metric.
  ///
  /// The detailed page is pushed onto the navigation stack, which allows users
  /// to return to the summary page using the back navigation.
  ///
  /// [page] is the widget that is displayed when navigating to the detailed view.
  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
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
          _buildMetricTile(
            title: 'Active Energy',
            subtitle: '122 cal',
            onTap: () => _navigateToPage(ActiveEnergyPage()),
            icon: Icons.flash_on,
          ),
          _buildMetricTile(
            title: 'Heart Rate',
            subtitle: 'No Data',
            onTap: () => _navigateToPage(HeartRatePage()),
            icon: Icons.favorite,
          ),
          _buildMetricTile(
            title: 'Sleep',
            subtitle: '6 hr 4 min',
            onTap: () => _navigateToPage(SleepPage()),
            icon: Icons.hotel,
          ),
          _buildMetricTile(
            title: 'Stand Hours',
            subtitle: 'No Data',
            onTap: () => _navigateToPage(StandHoursPage()),
            icon: Icons.accessibility_new,
          )
        ],
      ),
    );
  }

  /// Creates a ListTile for a health metric.
  ///
  /// This helper method generates a ListTile with a consistent design pattern
  /// for displaying health metrics on the summary page. It includes an icon,
  /// a title, a subtitle with the current metric value, and a trailing icon
  /// indicating that the tile can be tapped to reveal more information.
  ///
  /// [icon] is the leading icon for the metric.
  /// [title] is the name of the health metric to display.
  /// [subtitle] is the current value or status of the metric.
  /// [onTap] is the function to execute when the ListTile is tapped.
  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => onTap(),
    );
  }
}
