class Company {
  final String companyId;
  final String name;
  final int taxId;
  final String address;
  final int contact;
  final String email;
  final String sector;
  final String plan;
  final String password;

  Company({
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

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'],
      name: json['name'],
      taxId: json['taxId'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      sector: json['sector'],
      plan: json['plan'].toString(),
      password: json['password'] ?? '', // Valor padrão para null
    );
  }
}
