import 'package:front_end_moldme/dtos/project_dto.dart';

/// Represents a Data Transfer Object (DTO) for a chat.
class ChatDto {
  final String chatId;
  final String? projectId;
  final ProjectDto project;

  /// Constructor for ChatDTO.
  ChatDto({
    required this.chatId,
    required this.projectId,
    required this.project,
  });

  /// Converts a JSON map into a ChatDTO.
  factory ChatDto.fromJson(Map<String, dynamic> json) {
    return ChatDto(
      chatId: json['chatId'] as String,
      projectId: json['projectId'] as String,
      project: ProjectDto.fromJson(json['project']),
    );
  }

  /// Converts ChatDTO to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'projectId': projectId,
      'project': project.toJson(),
    };
  }
}
