import 'package:front_end_moldme/dtos/company_dto.dart';

/// Data Transfer Object (DTO) for a project.
class ProjectDto {
  final String? projectId;
  final String name;
  final String description;
  final int status; // Use string to match enum values from the backend.
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
  final String? companyId;
  final CompanyDto? company;

  ProjectDto({
    this.projectId,
    required this.name,
    required this.description,
    required this.status,
    required this.budget,
    required this.startDate,
    required this.endDate,
    this.companyId,
    this.company,
  });

  /// Converts a JSON map into a ProjectDto.
  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      projectId: json['projectId'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      budget: json['budget'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      companyId: json['companyId'],
      company: CompanyDto.fromJson(json['company']),
    );
  }

  /// Converts ProjectDto to a JSON map for API requests.
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'name': name,
      'description': description,
      'status': status,
      'budget': budget,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'companyId': companyId,
      'company': company?.toJson(),
    };
  }
}
