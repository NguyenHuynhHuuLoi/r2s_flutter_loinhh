import 'dart:io';
import 'student.dart';
import 'teacher.dart';

List<Student> students = [];
List<Teacher> teachers = [];

bool isValidEmail(String email) {
  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return regex.hasMatch(email);
}

double getValidatedScore(String label) {
  double? score;
  do {
    stdout.write('Enter $label (0-10): ');
    score = double.tryParse(stdin.readLineSync()!);
  } while (score == null || score < 0 || score > 10);
  return score;
}

Map<String, String> getBasicInfo() {
  stdout.write('Full Name: ');
  String? name = stdin.readLineSync();
  while (name == null || name.isEmpty) {
    stdout.write('Please enter a valid Full Name: ');
    name = stdin.readLineSync();
  }

  stdout.write('Gender: ');
  String? gender = stdin.readLineSync();
  while (gender == null || gender.isEmpty) {
    stdout.write('Please enter a valid Gender: ');
    gender = stdin.readLineSync();
  }

  stdout.write('PhoneNumber: ');
  String? phoneNumber = stdin.readLineSync();
  while (phoneNumber == null || phoneNumber.isEmpty) {
    stdout.write('Please enter a valid Phone Number: ');
    phoneNumber = stdin.readLineSync();
  }

  String? email;
  do {
    stdout.write('Email: ');
    email = stdin.readLineSync();
  } while (email == null || !isValidEmail(email));

  return {
    'name': name!,
    'gender': gender!,
    'phoneNumber': phoneNumber!,
    'email': email!,
  };
}


void createTeacher() {
  var info = getBasicInfo();

  stdout.write('Basic Salary: ');
  double basicSalary = double.parse(stdin.readLineSync()!);

  stdout.write('Subsidy: ');
  double subsidy = double.parse(stdin.readLineSync()!);

  teachers.add(Teacher(
    name: info['name']!,
    gender: info['gender']!,
    phone: info['phoneNumber']!,
    email: info['email']!,
    basicSalary: basicSalary,
    subsidy: subsidy,
  ));
}

void createStudent() {
  var info = getBasicInfo();

  stdout.write('Student ID: ');
  String studentId = stdin.readLineSync()!; // Make sure the input is not null

  double theory = getValidatedScore('Theory');
  double practice = getValidatedScore('Practice');

  students.add(Student(
    name: info['name']!,
    gender: info['gender']!,
    phone: info['phoneNumber']!,
    email: info['email']!,
    studentId: studentId,
    theory: theory,
    practice: practice,
  ));
}


void inputPerson() {
  stdout.write('Enter 1 for Teacher, 2 for Student: ');
  String? choice = stdin.readLineSync();

  if (choice == '1') {
    createTeacher();
  } else if (choice == '2') {
    createStudent();
  } else {
    print('Invalid choice.');
  }
}

void updateStudent() {
  stdout.write('Enter Student ID to update: ');
  String id = stdin.readLineSync()!;
  var student = students.firstWhere(
        (s) => s.studentId == id,
    orElse: () => null as Student,
  );

  if (student != null) {
    print('Updating student $id...');
    stdout.write('New Name: ');
    student.name = stdin.readLineSync()!;
    student.theory = getValidatedScore('Theory');
    student.practice = getValidatedScore('Practice');
  } else {
    print('Student not found.');
  }
}

void displayHighSalaryTeachers() {
  var filtered = teachers.where((t) => t.calculateSalary() > 1000);
  if (filtered.isEmpty) {
    print('No teacher has salary over \$1000.');
  } else {
    for (var teacher in filtered) {
      print(teacher);
    }
  }
}

void reportPassingStudents() {
  var passed = students.where((s) => s.calculateFinalMark() >= 6);
  if (passed.isEmpty) {
    print('No students passed the course.');
  } else {
    for (var student in passed) {
      print(student);
    }
  }
}

void main() {
  while (true) {
    print('\n--- Menu ---');
    print('1. Input data');
    print('2. Update student');
    print('3. Display teachers salary > 1000');
    print('4. Report student >=6 ');
    print('5. Quit');
    stdout.write('Choose an option: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        inputPerson();
        break;
      case '2':
        updateStudent();
        break;
      case '3':
        displayHighSalaryTeachers();
        break;
      case '4':
        reportPassingStudents();
        break;
      case '5':
        print('Đã dừng!');
        return;
      default:
        print('Invalid option.');
    }
  }
}
