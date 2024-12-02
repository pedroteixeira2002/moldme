
/// Data Transfer Object for Task
class CreateTaskDto {
  /// Title of the task
  final String titleName;

  /// Description of the task
  final String description;

  /// Date of the task
  final DateTime date;

  /// Status of the task
  final int status;

  /// File path of the task
  final String? filePath;

  /// Constructor for the TaskDto
  CreateTaskDto({
    required this.titleName,
    required this.description,
    required this.date,
    required this.status,
    this.filePath,
  });

  /// Converts a JSON map into a TaskDto object
  factory CreateTaskDto.fromJson(Map<String, dynamic> json) {
    return CreateTaskDto(
      titleName: json['titleName'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as int,
      filePath: json['filePath'] as String?,
    );
  }

  /// Converts a TaskDto object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'titleName': titleName,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'filePath': filePath,
    };
  }
}
