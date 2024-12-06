import 'package:front_end_moldme/dtos/company_dto.dart';

/// Data Transfer Object (DTO) for a project.
class ProjectDto {
  final String? projectId;
  final String name;
  final String description;
  final int status; // Enum values from the backend as integers.
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
      projectId: json['projectId'] as String?,
      name: json['name'] ?? 'Unknown', // Valor padrão para nome
      description: json['description'] ??
          'No description', // Valor padrão para descrição
      status: json['status'] ?? 0, // Valor padrão para status
      budget: (json['budget'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      companyId: json['companyId'] as String?,
      company: json['company'] != null
          ? CompanyDto.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  static ProjectDto empty() {
    return ProjectDto(
      projectId: '',
      name: '',
      description: '',
      status: 0,
      budget: 0.0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      companyId: '',
      company: CompanyDto.empty(),
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
