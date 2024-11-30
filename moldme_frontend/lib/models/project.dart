import 'package:front_end_moldme/models/company.dart';
import 'status.dart';


/// Represents a project.
class Project {
  final String projectId;
  final String name;
  final String description;
  final Status status;
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
  final String companyId;
  final Company company;

  Project({
    required this.projectId,
    required this.name,
    required this.description,
    required this.status,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.companyId,
    required this.company,
  });
}