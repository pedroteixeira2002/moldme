/// Represents a Task Data Transfer Object (DTO).
class TaskDto {
  final String taskId;
  final String titleName;
  final String description;
  final String date; // ISO 8601 formatted string
  final int status; // Enum as string
  final String projectId;
  final String employeeId;
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
    required this.employeeId,
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
      employeeId: json['employeeId'],
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
      'employeeId': employeeId,
      'fileContent': fileContent,
      'fileName': fileName,
      'mimeType': mimeType,
    };
  }
}
