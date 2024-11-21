import 'package:flutter/material.dart';
import 'package:tp3/Components/HomeScreen.dart';
import 'package:tp3/Components/RoomAvailabilityScreen.dart';
import 'package:tp3/Components/SessionsPage.dart';
import 'package:tp3/Components/StudentScheduleScreen.dart';
import 'package:tp3/Components/TeacherScheduleScreen.dart';
import 'package:tp3/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
