import 'message.dart';
import 'project.dart';

/// Represents a chat within a project.
class Chat {
  /// The unique identifier for the chat.
  final String chatId;

  /// The list of messages in the chat.
  final List<Message> messages;

  /// The associated project (nullable until explicitly fetched).
  final Project project;

  /// Constructor for ChatEntity.
  Chat({
    required this.chatId,
    required this.messages,
    required this.project,
  });
}
