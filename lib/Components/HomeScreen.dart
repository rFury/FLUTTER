import 'package:flutter/material.dart';
import 'package:tp3/Components/SessionsPage.dart';
import 'package:tp3/Components/classes.dart';
import 'package:tp3/Components/room.dart';
import 'package:tp3/Components/students.dart';
import 'package:tp3/Components/subjects.dart';
import 'package:tp3/Components/teachers.dart';
import 'package:tp3/Model/Subject.model.dart';
import 'package:tp3/Services/API.service.dart';
import 'package:tp3/Model/Session.model.dart';
import 'package:tp3/Model/Teacher.model.dart';
import 'package:tp3/Model/Class.model.dart';
import 'package:tp3/Model/Room.model.dart';
import 'SessionAddScreen.dart';

class HomeScreen extends StatelessWidget {
  final API apiService = API();

  List<Map<String, dynamic>> pages = [
  {'label': 'Rooms', 'widget': const RoomsPage()},
  {'label': 'Students', 'widget': const StudentsPage()},
  {'label': 'Teachers', 'widget': const TeachersPage()},
  {'label': 'Subjects', 'widget': const SubjectsPage()},
  {'label': 'Classes', 'widget': const ClassesPage()},
  {'label': 'Sessions', 'widget': const SessionsPage()},

];


  HomeScreen({super.key});

  Future<Map<String, Subject>> _fetchAllSubjects() async {
    List<Subject> subjectList = await apiService.getSubjects();
    return {for (var subject in subjectList) subject.subjectId: subject};
  }

  Future<Map<String, Teacher>> _fetchAllTeachers() async {
    List<Teacher> teacherList = await apiService.getTeachers();
    return {for (var teacher in teacherList) teacher.teacherId: teacher};
  }

  Future<Map<String, Class>> _fetchAllClasses() async {
    List<Class> classList = await apiService.getClasses();
    return {for (var classItem in classList) classItem.classId: classItem};
  }

  Future<Map<String, Room>> _fetchAllRooms() async {
    List<Room> roomList = await apiService.getRooms();
    return {for (var room in roomList) room.roomId: room};
  }

  @override
Widget build(BuildContext context) {
  Future<List<Session>> sessions = apiService.getSessions();
  Future<Map<String, Subject>> subjects = _fetchAllSubjects();
  Future<Map<String, Teacher>> teachers = _fetchAllTeachers();
  Future<Map<String, Class>> classes = _fetchAllClasses();
  Future<Map<String, Room>> rooms = _fetchAllRooms();

  return Scaffold(
    appBar: AppBar(
      title: const Text("Timetable Management"),
    ),
    body: Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Session>>(
            future: sessions,
            builder: (context, sessionSnapshot) {
              if (sessionSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (sessionSnapshot.hasError) {
                return Center(child: Text('Error: ${sessionSnapshot.error}'));
              } else if (!sessionSnapshot.hasData || sessionSnapshot.data!.isEmpty) {
                return const Center(child: Text('No sessions available.'));
              } else {
                return FutureBuilder<Map<String, Subject>>(
                  future: subjects,
                  builder: (context, subjectSnapshot) {
                    if (subjectSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (subjectSnapshot.hasError) {
                      return Center(child: Text('Error: ${subjectSnapshot.error}'));
                    } else if (!subjectSnapshot.hasData || subjectSnapshot.data!.isEmpty) {
                      return const Center(child: Text('No subjects available.'));
                    } else {
                      return FutureBuilder<Map<String, Teacher>>(
                        future: teachers,
                        builder: (context, teacherSnapshot) {
                          if (teacherSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (teacherSnapshot.hasError) {
                            return Center(child: Text('Error: ${teacherSnapshot.error}'));
                          } else {
                            return FutureBuilder<Map<String, Class>>(
                              future: classes,
                              builder: (context, classSnapshot) {
                                if (classSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (classSnapshot.hasError) {
                                  return Center(child: Text('Error: ${classSnapshot.error}'));
                                } else {
                                  return FutureBuilder<Map<String, Room>>(
                                    future: rooms,
                                    builder: (context, roomSnapshot) {
                                      if (roomSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (roomSnapshot.hasError) {
                                        return Center(child: Text('Error: ${roomSnapshot.error}'));
                                      } else {
                                        // Build the timetable table
                                        List<Session> sessionList = sessionSnapshot.data!;
                                        Map<String, Subject> subjectMap = subjectSnapshot.data!;
                                        Map<String, Teacher> teacherMap = teacherSnapshot.data!;
                                        Map<String, Class> classMap = classSnapshot.data!;
                                        Map<String, Room> roomMap = roomSnapshot.data!;

                                        List<Map<String, String>> timetable = [
                                          {
                                            "time": "9:00 AM",
                                            "Monday": "",
                                            "Tuesday": "",
                                            "Wednesday": "",
                                            "Thursday": "",
                                            "Friday": ""
                                          },
                                          {
                                            "time": "10:00 AM",
                                            "Monday": "",
                                            "Tuesday": "",
                                            "Wednesday": "",
                                            "Thursday": "",
                                            "Friday": ""
                                          },
                                          {
                                            "time": "11:00 AM",
                                            "Monday": "",
                                            "Tuesday": "",
                                            "Wednesday": "",
                                            "Thursday": "",
                                            "Friday": ""
                                          },
                                          {
                                            "time": "12:00 PM",
                                            "Monday": "",
                                            "Tuesday": "",
                                            "Wednesday": "",
                                            "Thursday": "",
                                            "Friday": ""
                                          },
                                          {
                                            "time": "1:00 PM",
                                            "Monday": "",
                                            "Tuesday": "",
                                            "Wednesday": "",
                                            "Thursday": "",
                                            "Friday": ""
                                          },
                                        ];

                                        for (var session in sessionList) {
                                          int timeIndex = _getTimeIndex(session.startTime);
                                          int timeGap = _getTimeIndex(session.endTime);
                                          String subjectName = subjectMap[session.subjectId]?.subjectName ?? "Unknown Subject";
                                          String teacherName = ("${teacherMap[session.teacherId]!.firstName} ${teacherMap[session.teacherId]!.lastName}") ??
                                              "Unknown Teacher";
                                          String className = classMap[session.classId]?.className ?? "Unknown Class";
                                          String roomName = roomMap[session.roomId]?.roomName ?? "Unknown Room";

                                          String cellContent = "$subjectName\n$teacherName\n$className\n$roomName";
                                          if (timeIndex != -1) {
                                            timetable[timeIndex][session.day] = cellContent;
                                            if (timeGap - timeIndex > 1) {
                                              timetable[timeIndex + 1][session.day] = cellContent;
                                            }
                                          }
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Table(
                                            border: TableBorder.all(),
                                            children: [
                                              const TableRow(
                                                children: [
                                                  TableCell(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Time',
                                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                                  TableCell(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Monday',
                                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                                  TableCell(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Tuesday',
                                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                                  TableCell(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Wednesday',
                                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                                  TableCell(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Thursday',
                                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                                  TableCell(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text('Friday',
                                                              style: TextStyle(fontWeight: FontWeight.bold)))),
                                                ],
                                              ),
                                              for (var row in timetable)
                                                TableRow(
                                                  children: [
                                                    TableCell(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(row['time']!,
                                                                style: const TextStyle(fontWeight: FontWeight.bold)))),
                                                    TableCell(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(row['Monday'] ?? "",
                                                                style: const TextStyle(fontSize: 12)))),
                                                    TableCell(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(row['Tuesday'] ?? "",
                                                                style: const TextStyle(fontSize: 12)))),
                                                    TableCell(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(row['Wednesday'] ?? "",
                                                                style: const TextStyle(fontSize: 12)))),
                                                    TableCell(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(row['Thursday'] ?? "",
                                                                style: const TextStyle(fontSize: 12)))),
                                                    TableCell(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(row['Friday'] ?? "",
                                                                style: const TextStyle(fontSize: 12)))),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute buttons evenly
  children: pages.map((page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page['widget']),
        );
      },
      child: Text(page['label']),
    );
  }).toList(),
)

      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SessionAddScreen()),
        );
      },
      tooltip: 'Add New Session',
      child: const Icon(Icons.add),
    ),
    
  );
}

  int _getTimeIndex(String startTime) {
    switch (startTime) {
      case "09:00":
        return 0;
      case "10:00":
        return 1;
      case "11:00":
        return 2;
      case "12:00":
        return 3;
      case "13:00":
        return 4;
      default:
        return -1;
    }
  }
  
}
