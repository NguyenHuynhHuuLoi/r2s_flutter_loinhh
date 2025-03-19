import 'dart:io';
import 'circleFunction.dart';

void main () {
  print('1. Calculate the area of a circle');
  print('2. Caculate the circumference of a circle');
  print('3. Exit');

  print('Enter your choice: ');
  int choice = int.parse(stdin.readLineSync()!);

  switch(choice){
    case 1:
      print('Enter the radius: ');
      double radius = double.parse(stdin.readLineSync()!);
      double area = calculateArea(radius);
      print('Area: $area');
      break;
    case 2:
      print('Enter the radius: ');
      double radius = double.parse(stdin.readLineSync()!);
      double circum = calculateCircumference(radius);
      print('Area: $circum');
      break;
      case 3:
        exitCircle();
        break;
      default:
        print('Please try again');
  }
}