import 'dart:convert';
import 'package:front_end_moldme/dtos/task_dto.dart';
import '../models/task.dart';
import '../models/status.dart';



/// Responsible for mapping between TaskEntity and TaskDTO.
class TaskMapper {

  /// Converts a `TaskDTO` to a `TaskEntity`.
  static Task fromDTO(TaskDto dto) {
    return Task(
      taskId: dto.taskId!,
      titleName: dto.titleName,
      description: dto.description,
      date: DateTime.parse(dto.date),
      status: Status.values.firstWhere((e) => e.name == dto.status),
      project : null,
      employee: null,
      fileContent: dto.fileContent != null ? base64Decode(dto.fileContent!) : null,
      fileName: dto.fileName,
      mimeType: dto.mimeType,
    );
  }

  /// Converts a `TaskEntity` to a `TaskDTO`.
  static TaskDto toDTO(Task entity) {
    return TaskDto(
      taskId: entity.taskId,
      titleName: entity.titleName,
      description: entity.description,
      date: entity.date.toIso8601String(),
      status: entity.status.index,
      projectId: entity.project?.projectId,
      employeeId: entity.employee?.employeeId,
      fileContent: entity.fileContent != null ? base64Encode(entity.fileContent!) : null,
      fileName: entity.fileName,
      mimeType: entity.mimeType,
    );
  }
}