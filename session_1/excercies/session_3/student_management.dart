import 'dart:io';
import 'student.dart';

void printInfo({ required  Student student}) {
  print('Id of student: ${student.id}');
  print('Name of student: ${student.name}');
  print('Student mark1: ${student.mark1}');
  print('Student mark2: ${student.mark2}');
  print('Student mark3: ${student.mark3}');
  print('Total marks of student: ${student.total()}');
  print('Average marks of student: ${student.average()}');
}

void inputInfo({ required  Student student}) {
  print('Enter id (Not duplicated): ');
  student.id = int.parse(stdin.readLineSync()!);
  
  print('Enter name of student:');
  student.name = stdin.readLineSync()!;

  print('Enter mark1 of student:');
  student.mark1 = num.parse(stdin.readLineSync()!);

  print('Enter mark2 of student:');
  student.mark2 = num.parse(stdin.readLineSync()!);

  print('Enter mark3 of student:');
  student.mark3 = num.parse(stdin.readLineSync()!);
}

// Tìm kiếm học sinh theo tên
void searchByName(List<Student> students, String name) {
  var found = false;
  for (var student in students) {
    if (student.name.toLowerCase() == name.toLowerCase()) {
      printInfo(student: student);
      found = true;
      break;
    }
  }
  if (!found) {
    print('Student with name "$name" not found.');
  }
}

// Tìm kiếm học sinh theo ID
void searchById(List<Student> students, int id) {
  var found = false;
  for (var student in students) {
    if (student.id == id) {
      printInfo(student: student);
      found = true;
      break;
    }
  }
  if (!found) {
    print('Student with ID "$id" not found.');
  }
}

void main() {
  List<Student> students = [];
  int choice;

  do{
  print('1. Add');
  print('2. Display');
  print('3. Search by name');
  print('4. Search by id');
  print('0. Exit');

  print('Your choice: ');
  choice = int.parse(stdin.readLineSync()!);


  switch (choice) {
    case 1:
      print('\nHow many students do you want to add?');
      int count = int.parse(stdin.readLineSync()!);

      for (int i = 0; i < count; i++) {
        print('Enter information of student ${0+1}');
        var student = Student();
        inputInfo(student: student);
        students.add(student);
      }

      break;

    case 2:
      for (var student in students) {
        printInfo(student: student);
      }
      break;
    case 3:
      print('Enter name to search: ');
      var name = stdin.readLineSync()!;
      searchByName(students, name);
      break;
    case 4:
      print('Enter Id to search: ');
      var id = int.parse(stdin.readLineSync()!);
      searchById(students, id);
      break;

    case 0:
      print('Exit');
      break;
    default:
      print('Please try again');
  }
}while (choice != 0);

 // inputInfo(student: student1);
 //  inputInfo(student: student2);
 //  inputInfo(student: student3);
 // student1.name = 'Jonh Doe 1';
 // student1.mark1 = 1;
 // student1.mark2 = 2;
 // student1.mark3 = 3;


}