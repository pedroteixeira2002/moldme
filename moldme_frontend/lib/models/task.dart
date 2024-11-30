import 'dart:typed_data';

import 'employee.dart';
import 'project.dart';
import 'status.dart';

/// Represents a task.
class Task {
  /// The unique identifier for the task.
  final String taskId;

  /// The title of the task.
  final String titleName;

  /// The description of the task.
  final String description;

  /// The date of the task.
  final DateTime date;

  /// The status of the task.
  final Status status;

  /// The project associated with the task.
  final Project project;

  /// The employee assigned to the task.
  final Employee employee;

  /// The file content of the task.
  final Uint8List? fileContent;

  /// The file name of the task.
  final String? fileName;

  /// The file type of the task.
  final String? mimeType;

  /// Constructor for Task.
  Task({
    required this.taskId,
    required this.titleName,
    required this.description,
    required this.date,
    required this.status,
    required this.project,
    required this.employee,
    this.fileContent,
    this.fileName,
    this.mimeType,
  });
}
