import 'package:flutter/material.dart';

class StudentScheduleScreen extends StatelessWidget {
  final String studentId;

  StudentScheduleScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Schedule")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Mathematics 101 - Room 101"),
            subtitle: Text("Monday 9:00 AM - 11:00 AM"),
          ),
          ListTile(
            title: Text("Physics 101 - Room 102"),
            subtitle: Text("Wednesday 10:00 AM - 12:00 PM"),
          ),
          // Additional sessions...
        ],
      ),
    );
  }
}
