import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vaccination.dart';

class VaccinationService {
  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection('vaccinations');

  static Future<void> addVaccination(String name, String vaccinatedDate, int durationMonths) async {
    try {
      final DateTime vaccinated = DateTime.parse(vaccinatedDate);
      final DateTime nextDate = _addMonths(vaccinated, durationMonths);

      await _collection.add({
        'name': name,
        'vaccinatedDate': vaccinatedDate,
        'durationMonths': durationMonths,
        'nextVaccinationDate': nextDate.toIso8601String().substring(0, 10),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding vaccination: $e');
      rethrow;
    }
  }

  static Future<void> updateVaccination(String id, String name, String vaccinatedDate, int durationMonths) async {
    try {
      final DateTime vaccinated = DateTime.parse(vaccinatedDate);
      final DateTime nextDate = _addMonths(vaccinated, durationMonths);

      await _collection.doc(id).update({
        'name': name,
        'vaccinatedDate': vaccinatedDate,
        'durationMonths': durationMonths,
        'nextVaccinationDate': nextDate.toIso8601String().substring(0, 10),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating vaccination: $e');
      rethrow;
    }
  }

  static Future<void> deleteVaccination(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      print('Error deleting vaccination: $e');
      rethrow;
    }
  }

  static Stream<List<Vaccination>> getVaccinations() {
    return _collection.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Vaccination(
          id: doc.id,
          name: data['name'] ?? '',
          vaccinatedDate: data['vaccinatedDate'] ?? '',
          durationMonths: data['durationMonths'] ?? 0,
          nextVaccinationDate: data['nextVaccinationDate'] ?? '',
        );
      }).toList();
    });
  }

  static DateTime _addMonths(DateTime date, int monthsToAdd) {
    int newYear = date.year + ((date.month + monthsToAdd - 1) ~/ 12);
    int newMonth = ((date.month + monthsToAdd - 1) % 12) + 1;
    int newDay = date.day;

    // Handle overflow in days for months like Feb, Apr, etc.
    int lastDay = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > lastDay) newDay = lastDay;

    return DateTime(newYear, newMonth, newDay);
  }
}