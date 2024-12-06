import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/chat_dto.dart';

class ChatService {
  static const String _baseUrl = 'https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net/api/Chat';
  final http.Client client;

  ChatService({http.Client? client}) : client = client ?? http.Client();

  /// Creates a new chat associated with a project ID.
  Future<bool> createChat(String projectId) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/createChat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ProjectId': projectId}),
    );

    return response.statusCode == 200;
  }

  /// Deletes a chat by its ID.
  Future<bool> deleteChat(String chatId) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/deleteChat/$chatId'),
    );

    return response.statusCode == 200;
  }

  /// Fetches a chat by its ID and returns a ChatDto.
  Future<ChatDto> getChat(String chatId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/get/$chatId'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ChatDto.fromJson(json);
    } else {
      throw Exception('Failed to load chat');
    }
  }
}
