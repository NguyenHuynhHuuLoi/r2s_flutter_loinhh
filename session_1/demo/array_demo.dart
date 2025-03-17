import 'dart:io';
import 'dart:math';

void main() {

  var random = Random();
    //random.nextInt(100) + 1; // 1 - 100
  List<int> list = List.generate(10, (_) => random.nextInt(100) + 1);
  print('Using for-in');
  for (int elenment in list) {
    print("Element is: $elenment");
  }

}