import 'project.dart';

/// Represents a chat within a project.
class Chat {
  /// The unique identifier for the chat.
  final String chatId;

  /// The associated project (nullable until explicitly fetched).
  final Project project;

  final String? projectId;

  /// Constructor for ChatEntity.
  Chat({
    required this.chatId,
    required this.project,
    required this.projectId,
  });
}
