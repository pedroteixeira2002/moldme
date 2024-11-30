import '../dtos/chat_dto.dart';
import '../models/chat.dart';

/// Maps between Chat and ChatDto.
class ChatMapper {

 /// Converts a ChatDto to a Chat model.
  static Chat fromDto(ChatDto dto) {
    return Chat(
      chatId: dto.chatId,
      messages: [],
      project: ,
    );
  }

  /// Converts a Chat model to a ChatDto.
  static ChatDto toDto(Chat chat) {
    return ChatDto(
      chatId: chat.chatId,
      projectId: chat.project.projectId,
    );
  }  
}
