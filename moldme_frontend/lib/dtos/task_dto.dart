import 'package:front_end_moldme/dtos/employee_dto.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import '../mappers/employee_mapper.dart';
import '../mappers/project_mapper.dart';


/// Represents a Task Data Transfer Object (DTO).
class TaskDto {
  final String taskId;
  final String titleName;
  final String description;
  final String date; // ISO 8601 formatted string
  final int status; // Enum as string
  final String? projectId;
  final ProjectDto project;
  final String employeeId;
  final EmployeeDto employee;
  final String? fileContent; // Base64 encoded string for file content
  final String? fileName;
  final String? mimeType;

  const TaskDto({
    required this.taskId,
    required this.titleName,
    required this.description,
    required this.date,
    required this.status,
    required this.projectId,
    required this.project,
    required this.employeeId,
    required this.employee,
    this.fileContent,
    this.fileName,
    this.mimeType,
  });

  /// Converts a JSON map to a `TaskDTO`.
  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      taskId: json['taskId'],
      titleName: json['titleName'],
      description: json['description'],
      date: json['date'],
      status: json['status'],
      projectId: json['projectId'],
      project: ProjectMapper.toDto(json['project']),
      employeeId: json['employeeId'],
      employee: EmployeeMapper.toDto(json['employee']),
      fileContent: json['fileContent'],
      fileName: json['fileName'],
      mimeType: json['mimeType'],
    );
  }

  /// Converts the `TaskDTO` to JSON.
  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'titleName': titleName,
      'description': description,
      'date': date,
      'status': status,
      'projectId': projectId,
      'project': project.toJson(),
      'employeeId': employeeId,
      'employee': employee.toJson(),
      'fileContent': fileContent,
      'fileName': fileName,
      'mimeType': mimeType,
    };
  }
}
