class Class {
  final String classId;
  final String subjectId;
  final String className;
  final List<String> students;

  Class({
    required this.classId,
    required this.subjectId,
    required this.className,
    required this.students,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      classId: json['class_id'],
      subjectId: json['subject_id'],
      className: json['class_name'],
      students: List<String>.from(json['students']),
    );
  }

  Map<String, dynamic> toJson() => {
        'class_id': classId,
        'subject_id': subjectId,
        'class_name': className,
        'students': students,
      };
}
