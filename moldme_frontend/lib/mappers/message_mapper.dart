import 'package:front_end_moldme/mappers/chat_mapper.dart';
import 'package:front_end_moldme/mappers/employee_mapper.dart';

import '../dtos/message_dto.dart';
import '../models/message.dart';

/// Maps between Message and MessageDto.
class MessageMapper {
  /// Converts a MessageDto to a Message model.
  static Future<Message> fromDto(MessageDto messageDto) async {
    return Message(
      messageId: messageDto.messageId,
      date: messageDto.date,
      text: messageDto.text,
      employee: EmployeeMapper.fromDto(messageDto.employee),
      chat: ChatMapper.fromDto(messageDto.chat),
    );
  }

    /// Converts a Message model to a MessageDto.
  static MessageDto toDto(Message message) {
    return MessageDto(
      messageId: message.messageId,
      date: message.date,
      text: message.text,
      employeeId: message.employee.employeeId,
      chatId: message.chat.chatId,
      employee: EmployeeMapper.toDto(message.employee),
      chat: ChatMapper.toDto(message.chat),
    );
  }
}
