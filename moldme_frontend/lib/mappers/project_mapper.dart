import 'package:front_end_moldme/mappers/company_mapper.dart';
import 'package:front_end_moldme/models/project.dart';
import 'package:front_end_moldme/models/status.dart';

import '../dtos/project_dto.dart';


/// Maps between Project and ProjectDto.
class ProjectMapper {
  /// Converts a ProjectDto to a Project model.
  static Project fromDto(ProjectDto dto) 
  {
    return Project(
      projectId: dto.projectId,
      name: dto.name,
      description: dto.description,
      status: Status.fromInt(dto.status),
      budget: dto.budget,
      startDate: dto.startDate,
      endDate: dto.endDate,
      companyId: dto.companyId,
      company: dto.company != null ? CompanyMapper.fromDto(dto.company!) : null
    );
  }

  /// Converts a Project model to a ProjectDto.
  static ProjectDto toDto(Project project) {
    return ProjectDto(
      projectId: project.projectId,
      name: project.name,
      description: project.description,
      status:  project.status.toInt(), // Convert enum to string
      budget: project.budget,
      startDate: project.startDate,
      endDate: project.endDate,
      companyId: project.companyId,
      company: project.company != null ? CompanyMapper.toDto(project.company!) : null,
    );
  }
}
