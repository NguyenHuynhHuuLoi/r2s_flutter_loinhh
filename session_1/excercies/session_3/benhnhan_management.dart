
import 'benhnhan.dart';
import 'dart:io';
void main() {
  // Creating an object of the BenhNhan class using the named constructor
  BenhNhan patient = BenhNhan.patient('John Doe', 30, 'Flu');

  // Printing the values of the properties
  print('Name: ${patient.name}');
  print('Age: ${patient.age}');
  print('Disease: ${patient.disease}');
}