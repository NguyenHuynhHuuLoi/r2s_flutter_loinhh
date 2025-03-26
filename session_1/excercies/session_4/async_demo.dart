void main() {
  print("Start");
  printData();
  print("End");
}

void printData() async {
  String data = await getData();
  print(data);
}

Future<String> getData() async {
  await Future.delayed(Duration(seconds: 3));
  return "Hello";
}