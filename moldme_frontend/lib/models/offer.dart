import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/models/project.dart';

import 'status.dart';

// ignore: depend_on_referenced_packages


/// Represents an offer made by a company for a project.
class Offer {
  final String offerId;
  final String companyId;
  final Company company;
  final String projectId;
  final Project project;
  final DateTime date;
  final Status status;
  final String description;

  Offer({
    required this.offerId,
    required this.companyId,
    required this.company,
    required this.projectId,
    required this.project,
    required this.date,
    required this.status,
    required this.description,
  });
}