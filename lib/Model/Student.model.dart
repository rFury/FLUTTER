class Student {
  final String studentId;
  final String firstName;
  final String lastName;
  final String email;

  Student({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      };
}
