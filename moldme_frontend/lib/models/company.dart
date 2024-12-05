import 'package:front_end_moldme/models/subscriptionPlan.dart';

class Company {
  String? companyId;
  String name;
  int taxId;
  String? address;
  int? contact;
  String email;
  String sector;
  SubscriptionPlan plan; // Assuming SubscriptionPlan is a String here
  String password;

  Company({
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
}
