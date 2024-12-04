class CompanyDto {
  final String companyId;
  final String name;
  final int taxId;
  final String address;
  final int contact;
  final String email;
  final String sector;
  final String plan;
  final String password;

  CompanyDto({
    required this.companyId,
    required this.name,
    required this.taxId,
    required this.address,
    required this.contact,
    required this.email,
    required this.sector,
    required this.plan,
    required this.password,
  });

  // Convert JSON from API to DTO
  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    return CompanyDto(
      companyId: json['companyId'],
      name: json['name'],
      taxId: json['taxId'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      sector: json['sector'],
      plan: json['plan'],
      password: json['password'],
    );
  }

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
      'plan': plan,
      'password': password,
    };
  }
}
