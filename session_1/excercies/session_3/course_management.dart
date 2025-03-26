import 'dart:io';
import 'course.dart';

// Function to input course details
void inputCourse({required Course course, required List<Course> courses}) {
  while (true) {
    stdout.write('Enter course code (Vd:  FW001, not duplicated): ');
    String enteredCode = stdin.readLineSync()!;
    bool isDuplicate = courses.any((c) => c.code == enteredCode);
    if (isDuplicate) {
      print('Ma khoa da ton tai, yeu cau nhap ma khac.');
    } else {
      course.code = enteredCode;
      break;
    }
  }

  stdout.write('Enter course name: ');
  course.name = stdin.readLineSync()!;

  stdout.write('Enter course duration (in hours): ');
  course.duration = double.parse(stdin.readLineSync()!);

  course.status = _getValidInput('Enter course status (active/in-active):', _isValidStatus);
  course.flag = _getValidInput('Enter course flag (optional/mandatory/N/A):', _isValidFlag);
}

// Function to get valid input based on the validation function
String _getValidInput(String prompt, bool Function(String) validator) {
  while (true) {
    stdout.write(prompt);
    String input = stdin.readLineSync()!;
    if (validator(input)) {
      return input;
    } else {
      print('Invalid input. Please try again.');
    }
  }
}

// Validation functions for the course status and flag
bool _isValidStatus(String status) {
  return status == 'active' || status == 'in-active';
}

bool _isValidFlag(String flag) {
  return flag == 'optional' || flag == 'mandatory' || flag == 'N/A';
}

// Function to display courses with 'optional' flag
void displayOptionalCourses(List<Course> courses) {
  List<Course> optionalCourses = Course.find(courses, 'flag', 'optional');
  if (optionalCourses.isEmpty) {
    print('No courses found with the flag "optional".');
  } else {
    for (var course in optionalCourses) {
      course.output();
      print('---------------------------');
    }
  }
}

// Function to search courses by a given attribute
List<Course> searchCourses(List<Course> courses, String attribute, dynamic value) {
  return Course.find(courses, attribute, value);
}

void main() {
  List<Course> courses = [];
  int choice;

  do {
    print('\n===== COURSE MANAGEMENT MENU =====');
    print('1. Add Course');
    print('2. Display All Optional Courses');
    print('3. Search Courses');
    print('0. Exit');
    stdout.write('Enter your choice: ');
    choice = int.tryParse(stdin.readLineSync()!) ?? -1;

    switch (choice) {
      case 1:
        var course = Course();
        inputCourse(course: course, courses: courses);
        courses.add(course);
        break;

      case 2:
        displayOptionalCourses(courses);
        break;

      case 3:
        stdout.write('Enter attribute to search by (code, name, status, flag): ');
        String attribute = stdin.readLineSync()!;
        stdout.write('Enter value to search: ');
        String value = stdin.readLineSync()!;
        var results = searchCourses(courses, attribute, value);

        if (results.isEmpty) {
          print('No courses found matching "$value".');
        } else {
          for (var course in results) {
            course.output();
            print('---------------------------');
          }
        }
        break;

      case 0:
        print('Exiting... Goodbye!');
        break;

      default:
        print('Invalid choice. Please try again.');
    }
  } while (choice != 0);
}
