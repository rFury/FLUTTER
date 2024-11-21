import 'package:flutter/material.dart';

class TeacherScheduleScreen extends StatelessWidget {
  final String teacherId; // Pass teacherId to filter schedule

  TeacherScheduleScreen({required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teacher Schedule")),
      body: ListView(
        children: [
          // Example sessions, replace with data from API
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
