import 'package:flutter/material.dart';
import 'package:tp3/Services/API.service.dart';
import 'package:tp3/Model/Session.model.dart';
import 'package:uuid/uuid.dart';

class SessionAddScreen extends StatefulWidget {
  @override
  _SessionAddScreenState createState() => _SessionAddScreenState();
}

class _SessionAddScreenState extends State<SessionAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final Uuid uuid = Uuid();

  final API _api = API(); // API instance to call functions

  // Controllers for date and time inputs
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  // Dropdown data and selections
  List<dynamic> _teachers = [];
  List<dynamic> _classes = [];
  List<dynamic> _subjects = [];
  List<dynamic> _rooms = [];
  String? _selectedTeacherId;
  String? _selectedClassId;
  String? _selectedSubjectId;
  String? _selectedRoomId;
  String? _selectedDay;

  // List of weekdays for the dropdown
  final List<String> _days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  // Fetch data for dropdowns
  Future<void> _fetchDropdownData() async {
    try {
      final teachers = await _api.getTeachers();
      final classes = await _api.getClasses();
      final subjects = await _api.getSubjects();
      final rooms = await _api.getRooms();

      setState(() {
        _teachers = teachers;
        _classes = classes;
        _subjects = subjects;
        _rooms = rooms;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: $error")),
      );
    }
  }

  // Submit form and create a new session
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedTeacherId != null &&
        _selectedClassId != null &&
        _selectedSubjectId != null &&
        _selectedRoomId != null &&
        _selectedDay != null) {
      final String startTime = _startTimeController.text;
      final String endTime = _endTimeController.text;
      final String sessionId = uuid.v4();

      final Session newSession = Session(
        sessionId: sessionId,
        subjectId: _selectedSubjectId!,
        teacherId: _selectedTeacherId!,
        roomId: _selectedRoomId!,
        classId: _selectedClassId!,
        sessionDate: "weekly",
        day: _selectedDay!,
        startTime: startTime,
        endTime: endTime,
      );

      try {
        await _api.addSession(newSession);
        Navigator.pop(context);
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Failed to add session. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Session"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Dropdown
                Text("Subject", style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  items: _subjects
                      .map((subject) => DropdownMenuItem<String>(
                            value: subject.subjectId.toString(),
                            child: Text(subject.subjectName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubjectId = value;
                    });
                  },
                  value: _selectedSubjectId,
                  decoration: InputDecoration(hintText: "Select subject"),
                  validator: (value) =>
                      value == null ? "Please select a subject." : null,
                ),
                SizedBox(height: 16),

                // Day Dropdown
                Text("Day", style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  items: _days
                      .map((day) => DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                    });
                  },
                  value: _selectedDay,
                  decoration: InputDecoration(hintText: "Select day"),
                  validator: (value) =>
                      value == null ? "Please select a day." : null,
                ),
                SizedBox(height: 16),

                // Instructor Dropdown
                Text("Instructor", style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  items: _teachers
                      .map((teacher) => DropdownMenuItem<String>(
                            value: teacher.teacherId.toString(),
                            child: Text("${teacher.firstName} ${teacher.lastName}"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeacherId = value;
                    });
                  },
                  value: _selectedTeacherId,
                  decoration: InputDecoration(hintText: "Select instructor"),
                  validator: (value) =>
                      value == null ? "Please select an instructor." : null,
                ),
                SizedBox(height: 16),

                // Class Dropdown
                Text("Class", style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  items: _classes
                      .map((classItem) => DropdownMenuItem<String>(
                            value: classItem.classId.toString(),
                            child: Text(classItem.className),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClassId = value;
                    });
                  },
                  value: _selectedClassId,
                  decoration: InputDecoration(hintText: "Select class"),
                  validator: (value) =>
                      value == null ? "Please select a class." : null,
                ),
                SizedBox(height: 16),

                // Room Dropdown
                Text("Room", style: TextStyle(fontSize: 18)),
                DropdownButtonFormField<String>(
                  items: _rooms
                      .map((room) => DropdownMenuItem<String>(
                            value: room.roomId.toString(),
                            child: Text(room.roomName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoomId = value;
                    });
                  },
                  value: _selectedRoomId,
                  decoration: InputDecoration(hintText: "Select room"),
                  validator: (value) =>
                      value == null ? "Please select a room." : null,
                ),
                SizedBox(height: 16),
                // Start Time Input
                Text("Start Time", style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: _startTimeController,
                  decoration:
                      InputDecoration(hintText: "Enter start time (e.g., 9:00 AM)"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the session start time.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // End Time Input
                Text("End Time", style: TextStyle(fontSize: 18)),
                TextFormField(
                  controller: _endTimeController,
                  decoration:
                      InputDecoration(hintText: "Enter end time (e.g., 11:00 AM)"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the session end time.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Add Session Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Add Session"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
