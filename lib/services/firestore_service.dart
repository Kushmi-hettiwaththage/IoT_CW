import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> saveGeofence(double lat, double lng, double radius) async {
    await _firestore.collection('geofences').add({
      'latitude': lat,
      'longitude': lng,
      'radius': radius,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> logGeofenceEvent(String event, LatLng location) async {
    await _firestore.collection('history').add({
      'event': event,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
