import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp3/Model/Session.model.dart';
import 'package:tp3/Services/API.service.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final String apiUrl = 'http://10.0.2.2:3000/sessions';
  final API _api = API(); // API instance to call functions
  List<Session> _session = [];
  bool isLoading = true;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController teacherController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      final session = await _api.getSessions();

      setState(() {
        _session = session;
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: $error")),
      );
      isLoading = false;
    }
  }

  Future<void> updateSession(String id) async {
    final token = await getJwtToken();
    final String subject = subjectController.text.trim();
    final String teacher = teacherController.text.trim();
    final String room = roomController.text.trim();
    final String classId = classController.text.trim();
    final String date = dateController.text.trim();
    final String startTime = startTimeController.text.trim();
    final String endTime = endTimeController.text.trim();

    if (subject.isEmpty ||
        teacher.isEmpty ||
        room.isEmpty ||
        classId.isEmpty ||
        date.isEmpty ||
        startTime.isEmpty ||
        endTime.isEmpty) {
      showError('Please fill all fields.');
      return;
    }

    try {
      final updatedSession = {
        'subject_id': subject,
        'teacher_id': teacher,
        'room_id': room,
        'class_id': classId,
        'session_date': date,
        'start_time': startTime,
        'end_time': endTime,
      };

      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {        'Authorization': 'Bearer $token',
'Content-Type': 'application/json'},
        body: json.encode(updatedSession),
      );

      if (response.statusCode == 200) {
        fetchSessions();
        Navigator.pop(context);
      } else {
        showError('Failed to update session.');
      }
    } catch (e) {
      showError('Error updating session. Please try again.');
    }
  }

    Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> deleteSession(String id) async {
    try {
      final token = await getJwtToken();
      final response = await http.delete(Uri.parse('$apiUrl/$id'),      
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        fetchSessions();
      } else {
        showError('Failed to delete session.');
      }
    } catch (e) {
      showError('Error deleting session: $e');
    }
  }

  void showSessionDialog({Session? sessionData}) {
    final isEditing = sessionData != null;

    // Fill the text fields with the session data if editing
    if (isEditing) {
      subjectController.text = sessionData.subjectId;
      teacherController.text = sessionData.teacherId;
      roomController.text = sessionData.roomId;
      classController.text = sessionData.classId;
      dateController.text = sessionData.sessionDate;
      startTimeController.text = sessionData.startTime;
      endTimeController.text = sessionData.endTime;
    } else {
      // Clear all fields if adding a new session
      subjectController.clear();
      teacherController.clear();
      roomController.clear();
      classController.clear();
      dateController.clear();
      startTimeController.clear();
      endTimeController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Session' : 'Add Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject ID'),
              ),
              TextField(
                controller: teacherController,
                decoration: const InputDecoration(labelText: 'Teacher ID'),
              ),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'Room ID'),
              ),
              TextField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Class ID'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                    labelText: 'Session Date (YYYY-MM-DD)'),
              ),
              TextField(
                controller: startTimeController,
                decoration: const InputDecoration(labelText: 'Start Time'),
              ),
              TextField(
                controller: endTimeController,
                decoration: const InputDecoration(labelText: 'End Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  updateSession(sessionData
                      .sessionId); // Ensure this field exists in your Session model
                } else {
                  // Logic to add a new session here
                  // Add a function to handle new session creation
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _session.isEmpty
              ? const Center(
                  child: Text(
                    'No sessions available. Add a new session!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _session.length,
                  itemBuilder: (context, index) {
                    final sessionData = _session[index];
                    return Card(
                      child: ListTile(
                        title: Text('Session: ${sessionData.sessionId}'),
                        subtitle: Text(
                          'Subject: ${sessionData.subjectId}, Teacher: ${sessionData.teacherId}, Room: ${sessionData.roomId}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  showSessionDialog(sessionData: sessionData),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  deleteSession(sessionData.sessionId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showSessionDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
