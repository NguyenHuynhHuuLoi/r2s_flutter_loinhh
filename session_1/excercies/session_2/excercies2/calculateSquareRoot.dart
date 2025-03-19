import 'dart:math';

dynamic calculateSquareRoot(dynamic input) {
  try {
    if (input is! num) {
      throw FormatException("Invalid input: Not a number.");
    }
    if (input < 0) {
      throw Exception("Square root of a negative number is not allowed.");
    }
    return sqrt(input);
  } catch (e) {
    return "Error: $e";
  }
}

void main() {
  print(calculateSquareRoot(4));
  print(calculateSquareRoot(-9));
  print(calculateSquareRoot("abc"));
}

