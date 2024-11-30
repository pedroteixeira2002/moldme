import 'chat.dart';
import 'employee.dart';

/// Represents a message in a chat.
class Message {
  /// The unique identifier for the message.
  final String messageId;

  /// The date and time when the message was sent.
  final DateTime date;

  /// The text content of the message.
  final String text;

  /// The employee who sent the message.
  final Employee employee;

  //The unique identifier for the chat associated with the message.
  final Chat chat;


  Message({
    required this.messageId,
    required this.date,
    required this.text,
    required this.employee,
    required this.chat,
  });
}
