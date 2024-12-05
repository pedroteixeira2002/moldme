import 'package:front_end_moldme/dtos/company_dto.dart';

class EmployeeDto {
  final String? employeeId;
  final String name;
  final String profession;
  final int nif;
  final String email;
  final int? contact;
  final String password;
  final String companyId;
  final CompanyDto? company;

  EmployeeDto({
    this.employeeId,
    required this.name,
    required this.profession,
    required this.nif,
    required this.email,
    this.contact,
    required this.password,
    required this.companyId,
    this.company,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    try {
      return EmployeeDto(
        employeeId: json['employeeId'] ?? '',
        name: json['name'] ?? '',
        profession: json['profession'] ?? '',
        nif: int.tryParse(json['nif']?.toString() ?? '0') ?? 0, // Garantir int
        email: json['email'] ?? '',
        contact:
            int.tryParse(json['contact']?.toString() ?? '0'), // Garantir int
        password: json['password'] ?? '',
        companyId: json['companyId'] ?? '',
        company: json['company'] != null
            ? CompanyDto.fromJson(json['company'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      print("Erro ao converter EmployeeDto: $e");
      print("Dados recebidos: $json");
      rethrow;
    }
  }

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
      'company': company?.toJson(),
    };
  }
}
