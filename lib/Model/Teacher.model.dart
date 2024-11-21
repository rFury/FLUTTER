class Teacher {
  final String teacherId;
  final String firstName;
  final String lastName;
  final String email;
  final String department;
  final String phone;

  Teacher({
    required this.teacherId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    required this.phone,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherId: json['teacher_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      department: json['department'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'teacher_id': teacherId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'department': department,
        'phone': phone,
      };
}
