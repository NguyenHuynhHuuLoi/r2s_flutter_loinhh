import 'dart:io';


void main() {
 print('Nhập số phần tử trong mảng: ');
 int n = int.parse(stdin.readLineSync()!);

 List<int> arr = [];
 print('Nhập các phần tử trong mảng');
 for (int i = 0; i < n; i ++){
   arr.add(int.parse(stdin.readLineSync()!));
 }

 print('Nhập phần tử cần xóa');
 int target = int.parse(stdin.readLineSync()!);

 List<int> result = arr.where((element) => element != target).toList();
 print('Mảng sau khi xóa phần tử được nhập là $target: $result');


}