class Session {
  final String sessionId;
  final String subjectId;
  final String teacherId;
  final String roomId;
  final String classId;
  final String sessionDate;
  final String day;
  final String startTime;
  final String endTime;

  Session({
    required this.sessionId,
    required this.subjectId,
    required this.teacherId,
    required this.roomId,
    required this.classId,
    required this.sessionDate,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      subjectId: json['subject_id'],
      teacherId: json['teacher_id'],
      roomId: json['room_id'],
      classId: json['class_id'],
      sessionDate: json['session_date'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'room_id': roomId,
        'class_id': classId,
        'session_date': sessionDate,
        'day': day,
        'start_time': startTime,
        'end_time': endTime,
      };
}
