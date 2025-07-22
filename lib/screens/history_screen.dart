import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('yyyy-MM-dd – kk:mm:ss').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofence History'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No history yet.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final event = data['event'];
              final lat = data['latitude'];
              final lng = data['longitude'];
              final timestamp = data['timestamp'] as Timestamp;

              return ListTile(
                leading: Icon(
                  event == 'enter' ? Icons.login : Icons.logout,
                  color: event == 'enter' ? Colors.green : Colors.red,
                ),
                title: Text('Dog ${event == 'enter' ? 'entered' : 'exited'} geofence'),
                subtitle: Text(
                    'Lat: $lat, Lng: $lng\nTime: ${formatTimestamp(timestamp)}'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
