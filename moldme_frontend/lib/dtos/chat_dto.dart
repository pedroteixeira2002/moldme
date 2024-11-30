/// Represents a Data Transfer Object (DTO) for a chat.
class ChatDto {
  final String chatId;
  final String projectId;

  /// Constructor for ChatDTO.
  ChatDto({
    required this.chatId,
    required this.projectId,
  });

  /// Converts a JSON map into a ChatDTO.
  factory ChatDto.fromJson(Map<String, dynamic> json) {
    return ChatDto(
      chatId: json['chatId'] as String,
      projectId: json['projectId'] as String,
    );
  }

  /// Converts ChatDTO to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'projectId': projectId,
    };
  }
}
