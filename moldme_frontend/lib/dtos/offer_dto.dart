import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';

/// Data Transfer Object (DTO) for an offer.
class OfferDto {
  final String offerId;
  final DateTime date;
  final int status;
  final String description;
  final String projectId;
  final String companyId;
  final CompanyDto company;
  final ProjectDto project;

  OfferDto({
    required this.offerId,
    required this.date,
    required this.status,
    required this.description,
    required this.projectId,
    required this.companyId,
    required this.company,
    required this.project,
  });

  // Converts a JSON map into an OfferDto.
  factory OfferDto.fromJson(Map<String, dynamic> json) {
    return OfferDto(
      offerId: json['offerId'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? 0, // Default to 0
      description: json['description'] ?? 'No description available',
      projectId: json['projectId'] ?? '',
      companyId: json['companyId'] ?? '',
      company: json['company'] != null
          ? CompanyDto.fromJson(json['company'])
          : CompanyDto.empty(), // Handle null
      project: json['project'] != null
          ? ProjectDto.fromJson(json['project'])
          : ProjectDto.empty(), // Handle null
    );
  }

  // Converts OfferDto to a JSON map for API requests.
  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
      'projectId': projectId,
      'companyId': companyId,
      'company': company.toJson(),
      'project': project.toJson(),
    };
  }
}
