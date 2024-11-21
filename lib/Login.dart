import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp3/Components/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login(String username, String password) async {
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  final url = Uri.parse('http://10.0.2.2:3000/login');
  print('Sending request to: $url'); // Debug log
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': username, 'password': password}),
  );

  print('Response status: ${response.statusCode}'); // Debug log
  print('Response body: ${response.body}'); // Debug log

  setState(() {
    _isLoading = false;
  });

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    String token = responseBody['token'];

    // Save token to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login successful!')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } else {
    setState(() {
      _errorMessage = 'Invalid username or password';
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      if (username.isNotEmpty && password.isNotEmpty) {
                        _login(username, password);
                      } else {
                        setState(() {
                          _errorMessage = 'Please enter both username and password';
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
            SizedBox(height: 16.0),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
