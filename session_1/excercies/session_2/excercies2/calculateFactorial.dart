import 'dart:io';

int calculateFactorial(int n) {
  if (n == 0) {
    return 1;
  } else {
    return n * calculateFactorial(n - 1);
  }
}

void main() {
  print('Nhập số cần tính giai thừa:');
  int n = int.parse(stdin.readLineSync()!);

  int result = calculateFactorial(n);
  print('Giai thừa của $n là: $result');
}