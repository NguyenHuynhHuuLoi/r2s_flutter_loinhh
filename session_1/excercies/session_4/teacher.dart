import 'person.dart';

class Teacher extends Person {
  double basicSalary;
  double subsidy;

  Teacher({
    required String name,
    required String gender,
    required String phone,
    required String email,
    required this.basicSalary,
    required this.subsidy,
  }) : super(name, gender, phone, email);

  double calculateSalary() {
    return basicSalary + subsidy;
  }

  @override
  String toString() {
    return 'Teacher: $name - Salary: \$${calculateSalary()}';
  }
}
