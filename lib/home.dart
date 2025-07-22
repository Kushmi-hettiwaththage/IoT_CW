import 'package:flutter/material.dart';
import 'screens/geofence_screen.dart';
import 'screens/temperature_screen.dart';
import 'screens/vaccination_screen.dart';
import 'screens/history_screen.dart'; // For home.dart


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Geofence & Location',
        'icon': Icons.location_on,
      },
      {
        'title': 'Temperature',
        'icon': Icons.thermostat,
      },
      {
        'title': 'Vaccinations',
        'icon': Icons.vaccines,
      },
      {
        'title': 'History',
        'icon': Icons.history,
      },
    ];

    const orangeColor = Color.fromARGB(255, 224, 162, 76); // Orange for icons and text

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PawMe',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: orangeColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9, // Make cards smaller
          ),
          itemBuilder: (context, index) {
            final feature = features[index];

            return GestureDetector(
              onTap: () {
                if (feature['title'] == 'Geofence & Location') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GeofenceScreen(),
                    ),
                  );
                } else if (feature['title'] == 'Temperature') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TemperatureScreen(),
                    ),
                  );
                } else if (feature['title'] == 'Vaccinations') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VaccinationScreen(),
                    ),
                  );
                } else if (feature['title'] == 'History') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                }

              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(feature['icon'], size: 48, color: orangeColor),
                    const SizedBox(height: 10),
                    Text(
                      feature['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: orangeColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
