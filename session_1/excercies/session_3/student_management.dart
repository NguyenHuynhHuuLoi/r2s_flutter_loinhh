import 'dart:io';
import 'student.dart';

// In thông tin 1 học sinh
void printInfo({required Student student}) {
  print('Id of student: ${student.id}');
  print('Name of student: ${student.name}');
  print('Student mark1: ${student.mark1}');
  print('Student mark2: ${student.mark2}');
  print('Student mark3: ${student.mark3}');
  print('Total marks of student: ${student.total()}');
  print('Average marks of student: ${student.average()}');
}

// Nhập thông tin 1 học sinh, có kiểm tra trùng ID
void inputInfo({required Student student, required List<Student> students}) {
  while (true) {
    stdout.write('Enter id (Not duplicated): ');
    int enteredId = int.parse(stdin.readLineSync()!);

    bool isDuplicate = students.any((s) => s.id == enteredId);
    if (isDuplicate) {
      print('ID đã tồn tại. Vui lòng nhập lại.');
    } else {
      student.id = enteredId;
      break;
    }
  }

  stdout.write('Enter name of student: ');
  student.name = stdin.readLineSync()!;

  stdout.write('Enter mark1 of student: ');
  student.mark1 = num.parse(stdin.readLineSync()!);

  stdout.write('Enter mark2 of student: ');
  student.mark2 = num.parse(stdin.readLineSync()!);

  stdout.write('Enter mark3 of student: ');
  student.mark3 = num.parse(stdin.readLineSync()!);
}


void addStudents(List<Student> students) {
  stdout.write('\nHow many students do you want to add? ');
  int count = int.parse(stdin.readLineSync()!);

  for (int i = 0; i < count; i++) {
    print('\nEnter information for student ${i + 1}:');
    var student = Student();
    inputInfo(student: student, students: students);
    students.add(student);
  }
}


List<Student> searchByName(List<Student> students, String name) {
  return students.where((s) => s.name.toLowerCase() == name.toLowerCase()).toList();
}


Student? searchById(List<Student> students, int id) {
  try {
    return students.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
}



void main() {
  List<Student> students = [];
  int choice;

  do {
    print('\n===== MENU =====');
    print('1. Add Students');
    print('2. Display All Students');
    print('3. Search by Name');
    print('4. Search by ID');
    print('0. Exit');
    stdout.write('Your choice: ');
    choice = int.tryParse(stdin.readLineSync()!) ?? -1;

    switch (choice) {
      case 1:
        addStudents(students);
        break;

      case 2:
        if (students.isEmpty) {
          print('No students to display.');
        } else {
          for (var student in students) {
            printInfo(student: student);
            print('----------------------------');
          }
        }
        break;

      case 3:
        stdout.write('Enter name to search: ');
        String name = stdin.readLineSync()!;
        var results = searchByName(students, name);

        if (results.isEmpty) {
          print('No student found with name "$name".');
        } else {
          for (var student in results) {
            printInfo(student: student);
            print('----------------------------');
          }
        }
        break;

      case 4:
        stdout.write('Enter ID to search: ');
        int id = int.parse(stdin.readLineSync()!);
        var student = searchById(students, id);

        if (student == null) {
          print('No student found with ID $id.');
        } else {
          printInfo(student: student);
        }
        break;

      case 0:
        print('Goodbye!');
        break;

      default:
        print('Please try again.');
    }
  } while (choice != 0);

}
