import 'package:front_end_moldme/models/subscriptionPlan.dart';

class CompanyDto {
  final String? companyId;
  final String name;
  final int taxId;
  final String? address;
  final int? contact;
  final String email;
  final String sector;
  final SubscriptionPlan plan; // Assuming SubscriptionPlan is a String here
  final String password;

  CompanyDto({
    this.companyId,
    required this.name,
    required this.taxId,
    this.address,
    this.contact,
    required this.email,
    required this.sector,
    required this.plan,
    required this.password,
  });

  // Convert DTO to JSON for API communication
  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'name': name,
      'taxId': taxId,
      'address': address,
      'contact': contact,
      'email': email,
      'sector': sector,
      'plan': plan.index,
      'password': password,
    };
  }

  // Convert JSON from API to DTO
factory CompanyDto.fromJson(Map<String, dynamic> json) {
    return CompanyDto(
      companyId:
          json['companyId'] ?? '', // Garante um valor padrão caso esteja nulo
      name: json['name'] ?? 'Unknown', // Valor padrão para nome
      taxId: json['taxId'] ?? 0, // Valor padrão para taxId
      address: json['address'] ??
          'No address available', // Valor padrão para address
      contact: json['contact'] != null
          ? int.tryParse(json['contact'].toString())
          : null,
      email: json['email'] ?? 'No email provided', // Valor padrão para email
      sector: json['sector'] ?? 'Unknown', // Valor padrão para setor
      plan: SubscriptionPlan
          .values[json['plan'] ?? 0], // Converte plano ou usa o padrão
      password: json['password'] ?? '', // Valor padrão para senha
    );
  }



  factory CompanyDto.empty() {
    return CompanyDto(companyId: '', name: '',taxId: 0,address: "",contact: 0,email: "",sector: "",plan: SubscriptionPlan.none, password: "");
  }
}
