import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tp3/Model/Room.model.dart';
import 'package:tp3/Model/Teacher.model.dart';
import 'package:tp3/Model/Subject.model.dart';
import 'package:tp3/Model/Session.model.dart';
import 'package:tp3/Model/Student.model.dart';
import 'package:tp3/Model/Class.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final String baseUrl = 'http://10.0.2.2:3000';

  // Retrieve JWT Token from SharedPreferences
  Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Modify loginUser function to store JWT token
  Future<String?> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/login'); // Make sure this is your correct login URL

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String token = responseBody['token'];

      // Save token to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt_token', token);

      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  // Add Authorization header in each request
  Future<List<Room>> getRooms() async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  Future<List<Teacher>> getTeachers() async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/teachers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Future<List<Subject>> getSubjects() async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/subjects'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  Future<List<Session>> getSessions() async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/sessions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  Future<List<Student>> getStudents() async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/students'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<List<Class>> getClasses() async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/classes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Class.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<Subject> getSubjectById(String id) async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/subjects/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Subject.fromJson(data);
    } else {
      throw Exception('Failed to load subject with id $id');
    }
  }

  Future<Teacher> getTeacherById(String id) async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/teachers/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Teacher.fromJson(data);
    } else {
      throw Exception('Failed to load teacher with id $id');
    }
  }

  Future<Class> getClassById(String id) async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/classes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Class.fromJson(data);
    } else {
      throw Exception('Failed to load class with id $id');
    }
  }

  Future<Room> getRoomById(String id) async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Room.fromJson(data);
    } else {
      throw Exception('Failed to load room with id $id');
    }
  }

  Future<void> addSession(Session session) async {
    final token = await getJwtToken();
    if (token == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse('$baseUrl/sessions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(session.toJson()),
    );

    if (response.statusCode == 201) {
      // Session successfully created
      return;
    } else {
      throw Exception('Failed to add session');
    }
  }
}
