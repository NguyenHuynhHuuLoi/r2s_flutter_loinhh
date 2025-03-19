import 'dart:io';

void main(){
  int age = 0;

  while (true) {
    print('Enter age:');
    try {
      age = int.parse(stdin.readLineSync()!);
      break;
    } catch (e) {
      print('Error: $e');
    }
  }

  print('Age: $age');

}