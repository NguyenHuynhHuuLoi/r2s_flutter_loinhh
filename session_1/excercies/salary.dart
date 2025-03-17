import 'dart:io';

void main(List<String> arguments) {
  String grade;
  num salary, allowance, totalSalary;

  print('Enter salary: ');
  salary = num.parse(stdin.readLineSync()!);

  print('Enter grade: ');
  grade = stdin.readLineSync()!;
// Sử dụng switch thay vì if-else
  switch (grade) {
    case 'A':
      allowance = 300;
      break;
    case 'B':
      allowance = 250;
      break;
    default:
      allowance = 100;
  }

  totalSalary = salary + allowance;
  print('Total salary: $totalSalary');
}