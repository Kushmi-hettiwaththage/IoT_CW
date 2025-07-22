import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  // Reference to Realtime Database node 'temperatures'
  static final DatabaseReference _rtdbRef =
      FirebaseDatabase.instance.ref('temperatures');

  /// Save temperature to Realtime Database (overwrite)
  static Future<void> saveTemperature(double temperature) async {
    final String timestamp = DateTime.now().toIso8601String();

    await _rtdbRef.set({
      'temperature': temperature,
      'timestamp': timestamp,
    });
  }
}
