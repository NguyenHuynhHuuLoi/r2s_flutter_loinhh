import 'dart:io';
import 'dart:math';

double calculateArea(double radius){
  return pi * radius * radius;
}

double calculateCircumference (double radius){
  return 2 * pi * radius;
}

void exitCircle(){
  print('Stop program');
  exit(0);
}