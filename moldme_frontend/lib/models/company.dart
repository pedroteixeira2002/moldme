class Company {
  final String companyId;
  final String name;
  final int taxId;
  final String address;
  final int contact;
  final String email;
  final String sector;
  final String plan; // Assuming SubscriptionPlan is a String here
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
}
