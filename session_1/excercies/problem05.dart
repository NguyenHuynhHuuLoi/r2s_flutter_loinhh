import 'dart:io';
import 'dart:math';

void main() {
  print('Nhập số phần tử trong mảng:');
  int n = int.parse(stdin.readLineSync()!);

  List<int> arr = [];

  print('Nhập các phần tử trong mảng');
  for (int i = 0; i < n ; i++){
    arr.add((int.parse(stdin.readLineSync()!)));
  }

  List<int> reversedA = arr.reversed.toList();
  print('Mảng sau khi đảo ngược: $reversedA');
  
}