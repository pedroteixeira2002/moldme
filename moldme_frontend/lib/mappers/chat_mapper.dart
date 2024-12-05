import 'package:front_end_moldme/mappers/project_mapper.dart';

import '../dtos/chat_dto.dart';
import '../models/chat.dart';

/// Maps between Chat and ChatDto.
class ChatMapper {

 /// Converts a ChatDto to a Chat model.
  static Chat fromDto(ChatDto dto) {
    return Chat(
      chatId: dto.chatId!,
      projectId: dto.projectId,
      project: ProjectMapper.fromDto(dto.project)
    );
  }

  /// Converts a Chat model to a ChatDto.
  static ChatDto toDto(Chat chat) {
    return ChatDto(
      chatId: chat.chatId,
      projectId: chat.project.projectId,
      project: ProjectMapper.toDto(chat.project)
    );
  }  
}
