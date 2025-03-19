
num sum (num num1, num num2) {
  return num1 + num2;
}

num subtract(num num1, num num2) {
  return num1 - num2;
}

//void -> nothing , khong tra ve gia tri
void printNumber(String message, num number) {
  print('Number: $number');
}

void printUserInfo({required  name, required int age}) {
  print('Name: $name, Age: $age');
}

void main(){
  // printUserInfo('John', 10);

  printUserInfo(name: 'John', age: 25);
  printUserInfo(age: 19, name: 'Doe');
  
  // num num1 = 10;
  // num num2 = 20;
  //
  // printNumber('Sum', sum(num1, num2));
  // // print('Subtract: ${subtract(num1, num2)}');
  // printNumber('Substract', subtract(num1, num2));
}