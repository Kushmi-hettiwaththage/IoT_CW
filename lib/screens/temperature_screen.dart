import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/bottom_nav_bar.dart';

class TemperatureScreen extends StatelessWidget {
  const TemperatureScreen({super.key});

  // Function to get status based on temperature
  String getTempStatus(double temp) {
    if (temp < 37.5) return "Low";
    if (temp > 39.5) return "High";
    return "Normal";
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "High":
        return Colors.red;
      case "Low":
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference tempRef =
        FirebaseDatabase.instance.ref('temperatures');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dog Temperature",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Latest Temperature:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            StreamBuilder<DatabaseEvent>(
              stream: tempRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  final double temperature =
                      double.tryParse(data['temperature'].toString()) ?? 0.0;

                  final String status = getTempStatus(temperature);
                  final Color statusColor = getStatusColor(status);

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Row(
                        children: [
                          const Icon(Icons.thermostat,
                              color: Colors.orange, size: 40),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Body Temperature",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "$temperature °C",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Status: $status",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error fetching temperature.");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
