import 'package:flutter/material.dart';
import 'package:pawme/home.dart';
import '../screens/geofence_screen.dart';
import '../screens/temperature_screen.dart';
import '../screens/vaccination_screen.dart';
import '../screens/history_screen.dart'; // ✅ import

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const GeofenceScreen();
        break;
      case 2:
        screen = const TemperatureScreen();
        break;
      case 3:
        screen = const VaccinationScreen();
        break;
      case 4:
        screen = const HistoryScreen(); // ✅ Added
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Geofence',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.thermostat),
          label: 'Temp',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.vaccines),
          label: 'Vaccine',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history), // ✅ History Tab
          label: 'History',
        ),
      ],
    );
  }
}
