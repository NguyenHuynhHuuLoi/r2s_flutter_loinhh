import 'dart:io';

void main() {
  int number, result;

  do {
    print('Enter number: ');
    number = int.parse(stdin.readLineSync()!);
  } while (number < 2 || number > 9);
  for (int i = 2; i <=9; i++) {
    result = number * i;
    print('$number * $i = $result');
  }
}