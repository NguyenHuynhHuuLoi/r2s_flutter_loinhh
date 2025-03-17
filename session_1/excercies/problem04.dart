import 'dart:io';
import 'dart:math';

void main() {
  print ('Nhập số phần tử trong mảng: ');
  int n = int.parse(stdin.readLineSync()!);

  List<int> arr = [];

  print('Nhập các phần tử trong mảng');
  for (int i = 0; i < n ; i ++){
    arr.add(int.parse(stdin.readLineSync()!));
  }

  int sum = 0;
  for (int i = 0; i < n; i++){
    sum += arr[i];
  }

  double average = sum / n ;
  print('Trung bình mảng: $average');
  
}