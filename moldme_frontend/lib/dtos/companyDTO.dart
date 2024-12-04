class CompanyDTO {
  final String name;
  final int taxId;
  final String address;
  final int contact;
  final String email;
  final String sector;
  final int plan;
  final String password;

  CompanyDTO({
    required this.name,
    required this.taxId,
    required this.address,
    required this.contact,
    required this.email,
    required this.sector,
    required this.plan,
    required this.password,
  });

  /// Factory para criar o DTO a partir de um JSON.
factory CompanyDTO.fromJson(Map<String, dynamic> json) {
    return CompanyDTO(
      name: json['name'] ?? 'Unknown Name',
      taxId: json['taxId'] ?? 0,
      address: json['address'] ?? 'Unknown Address',
      contact: json['contact'] ?? 0,
      email: json['email'] ?? 'Unknown Email',
      sector: json['sector'] ?? 'Unknown Sector',
      plan: json['plan'] ?? 0,
      password: json['password'] ?? '',
    );
  }

  /// Método para converter o DTO para JSON.
  Map<String, dynamic> toJson() {
    return {
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
