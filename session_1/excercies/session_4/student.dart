import 'person.dart';

class Student extends Person {
  String studentId;
  double theory;
  double practice;

  Student({
    required String name,
    required String gender,
    required String phone,
    required String email,
    required this.studentId,
    required this.theory,
    required this.practice,
  }) : super(name, gender, phone, email);

  double calculateFinalMark() {
    return (theory + practice) / 2;
  }

  @override
  String toString() {
    return 'Student: $name - ID: $studentId - Final Mark: ${calculateFinalMark()}';
  }
}
