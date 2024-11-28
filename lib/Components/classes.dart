import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final String apiUrl = 'http://10.0.2.2:3000/classes';
  List<Map<String, dynamic>> classes = [];
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController studentsController = TextEditingController();

    Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    setState(() => isLoading = true);

    try {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
          if (response.statusCode == 200) {
        setState(() {
          classes = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        showError('Failed to fetch classes. Please try again later.');
      }
    } catch (e) {
      showError('Error fetching classes: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> addClass() async {
    final String name = nameController.text.trim();
    final String subject = subjectController.text.trim();
    final String students = studentsController.text.trim();

    if (name.isEmpty || subject.isEmpty || students.isEmpty) {
      showError('Please fill all fields.');
      return;
    }

    try {
      final newClass = {
        'class_name': name,
        'subject_id': subject,
        'students': students.split(','),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newClass),
      );

      if (response.statusCode == 201) {
        fetchClasses();
        Navigator.pop(context);
      } else {
        showError('Failed to add class.');
      }
    } catch (e) {
      showError('Error adding class. Please try again.');
    }
  }

  Future<void> updateClass(String id) async {
    final String name = nameController.text.trim();
    final String subject = subjectController.text.trim();
    final String students = studentsController.text.trim();

    if (name.isEmpty || subject.isEmpty || students.isEmpty) {
      showError('Please fill all fields.');
      return;
    }

    try {
      final updatedClass = {
        'class_name': name,
        'subject_id': subject,
        'students': students.split(','),
      };

      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedClass),
      );

      if (response.statusCode == 200) {
        fetchClasses();
        Navigator.pop(context);
      } else {
        showError('Failed to update class.');
      }
    } catch (e) {
      showError('Error updating class. Please try again.');
    }
  }

  Future<void> deleteClass(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200) {
        fetchClasses();
      } else {
        showError('Failed to delete class.');
      }
    } catch (e) {
      showError('Error deleting class: $e');
    }
  }

  void showClassDialog({Map<String, dynamic>? classData}) {
    final isEditing = classData != null;

    if (isEditing) {
      nameController.text = classData['class_name'];
      subjectController.text = classData['subject_id'];
      studentsController.text = classData['students'].join(',');
    } else {
      nameController.clear();
      subjectController.clear();
      studentsController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Class' : 'Add Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject ID'),
              ),
              TextField(
                controller: studentsController,
                decoration: const InputDecoration(labelText: 'Students (comma separated)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => isEditing
                  ? updateClass(classData['id'])
                  : addClass(),
              child: Text(isEditing ? 'Update' : 'Add'),
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
      appBar: AppBar(title: const Text('Classes')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : classes.isEmpty
              ? const Center(
                  child: Text(
                    'No classes available. Add a new class!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final classData = classes[index];
                    return Card(
                      child: ListTile(
                        title: Text(classData['class_name']),
                        subtitle: Text('Subject ID: ${classData['subject_id']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => showClassDialog(classData: classData),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteClass(classData['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showClassDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
