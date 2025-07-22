import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawme/services/firestore_service.dart';
import '../widgets/bottom_nav_bar.dart';

class GeofenceScreen extends StatefulWidget {
  const GeofenceScreen({super.key});

  @override
  State<GeofenceScreen> createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  LatLng? geofenceCenter;
  double radius = 100;
  LatLng? dogLocation;

  final List<double> radiusOptions = [50, 100, 200, 300, 500, 750, 1000];
  final DatabaseReference dogLocationRef =
      FirebaseDatabase.instance.ref('location');

  bool isLoading = true;
  bool showAddForm = false;

  @override
  void initState() {
    super.initState();
    _loadGeofenceFromFirestore();
    _listenToDogLocation();
  }

  Future<void> _loadGeofenceFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('geofences')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        geofenceCenter = LatLng(data['latitude'], data['longitude']);
        radius = data['radius'].toDouble();
        isLoading = false;
        showAddForm = false;
      });
    } else {
      setState(() {
        showAddForm = true;
        isLoading = false;
      });
    }
  }

  void _listenToDogLocation() {
    dogLocationRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null &&
          data.containsKey('latitude') &&
          data.containsKey('longitude')) {
        setState(() {
          dogLocation = LatLng(
            double.parse(data['latitude'].toString()),
            double.parse(data['longitude'].toString()),
          );
        });
      }
    });
  }

  Future<void> _getDeviceLocationAndSave() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    final newLocation = LatLng(pos.latitude, pos.longitude);

    await FirestoreService.saveGeofence(
      newLocation.latitude,
      newLocation.longitude,
      radius,
    );

    await _loadGeofenceFromFirestore();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Geofence saved.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Geofence', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 221, 152, 33),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt),
            tooltip: 'Add New Geofence',
            onPressed: () {
              setState(() {
                showAddForm = true;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (geofenceCenter != null)
            FlutterMap(
              options: MapOptions(
                center: geofenceCenter,
                zoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: geofenceCenter!,
                      color: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                      useRadiusInMeter: true,
                      radius: radius,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: geofenceCenter!,
                      child: const Icon(Icons.location_on,
                          size: 40, color: Colors.red),
                    ),
                    if (dogLocation != null)
                      Marker(
                        width: 40,
                        height: 40,
                        point: dogLocation!,
                        child: const Icon(Icons.pets,
                            size: 40, color: Color.fromARGB(155, 29, 39, 191)),
                      ),
                  ],
                )
              ],
            ),
          if (showAddForm)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select Radius (meters)",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      DropdownButton<double>(
                        value: radius,
                        isExpanded: true,
                        items: radiusOptions.map((value) {
                          return DropdownMenuItem<double>(
                            value: value,
                            child: Text("$value meters"),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            radius = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.my_location),
                          onPressed: _getDeviceLocationAndSave,
                          label: const Text("Use My Location"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
