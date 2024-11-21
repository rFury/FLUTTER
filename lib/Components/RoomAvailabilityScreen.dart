import 'package:flutter/material.dart';

class RoomAvailabilityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Room Availability")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Room 101"),
            subtitle: Text("Available: Monday 1:00 PM - 3:00 PM"),
          ),
          ListTile(
            title: Text("Room 102"),
            subtitle: Text("Occupied: Monday 9:00 AM - 11:00 AM"),
          ),
          // Additional room availability info...
        ],
      ),
    );
  }
}
