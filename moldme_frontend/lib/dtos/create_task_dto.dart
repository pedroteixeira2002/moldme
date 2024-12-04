import 'dart:typed_data';
import 'dart:convert';

class CreateTaskDto {
  final String titleName;
  final String description;
  final DateTime date;
  final int status;
  final Uint8List? fileContent;
  final String? fileName;
  final String? mimeType;

  CreateTaskDto({
    required this.titleName,
    required this.description,
    required this.date,
    required this.status,
    this.fileContent,
    this.fileName,
    this.mimeType,
  });

  Map<String, dynamic> toJson() {
    return {
      'titleName': titleName,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
      'fileContent': fileContent != null ? base64Encode(fileContent!) : null,
      'fileName': fileName,
      'mimeType': mimeType,
      'filePath': "", 
    };
  }
}