import 'dart:io';

String validateAge(dynamic age) {
  try {
    if (age is! int) {
      throw FormatException("Invalid input: Age must be an integer.");
    }
    if (age < 0) {
      throw RangeError("Age cannot be negative.");
    }
    if (age < 18) {
      throw Exception("User is underage.");
    }
    return "Access granted.";
  } catch (e) {
    return "Error: $e";
  }
}

void main() {
  print(validateAge(21));
  print(validateAge(-5));
  print(validateAge("abc"));
}
