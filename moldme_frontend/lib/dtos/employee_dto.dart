import 'package:front_end_moldme/dtos/company_dto.dart';

class EmployeeDto {
  final String employeeId;
  final String name;
  final String profession;
  final int nif;
  final String email;
  final int? contact;
  final String password;
  final String companyId;
  final CompanyDto? company; // Tornar nullable para evitar erros

  EmployeeDto({
    required this.employeeId,
    required this.name,
    required this.profession,
    required this.nif,
    required this.email,
    this.contact,
    required this.password,
    required this.companyId,
    this.company, // Permite null
  });

  // Convert JSON from API to DTO
  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      employeeId: json['employeeId'],
      name: json['name'],
      profession: json['profession'],
      nif: json['nif'],
      email: json['email'],
      contact: json['contact'],
      password: json['password'],
      companyId: json['companyId'],
      company: json['company'] != null
          ? CompanyDto.fromJson(json['company'])
          : null, // Verificação para evitar erro
    );
  }

  // Convert DTO to JSON for API communication
  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'name': name,
      'profession': profession,
      'nif': nif,
      'email': email,
      'contact': contact,
      'password': password,
      'companyId': companyId,
      'company': company?.toJson(), // Evita null pointer exception
    };
  }
}
