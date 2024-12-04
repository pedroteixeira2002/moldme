import 'package:front_end_moldme/models/company.dart';

class Employee {
  final String employeeId;
  final String name;
  final String profession;
  final int nif;
  final String email;
  final int? contact;
  final String password;
  final String companyId;
  final Company company;


  Employee({
    required this.employeeId,
    required this.name,
    required this.profession,
    required this.nif,
    required this.email,
    this.contact,
    required this.password,
    required this.companyId,
    required this.company,
  });
}
