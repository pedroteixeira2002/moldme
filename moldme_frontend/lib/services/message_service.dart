import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/message_dto.dart';


class MessageService {
  static const String _baseUrl = 'https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net/api/Message';
  final http.Client client;

  MessageService({http.Client? client}) : client = client ?? http.Client();

  // Get messages for a specific chat
  Future<List<MessageDto>> getMessages(String chatId) async {
    final url = Uri.parse('$_baseUrl/$chatId');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      try {
        // Decodificar o JSON diretamente como uma lista
        final List<dynamic> data = json.decode(response.body);

        // Mapear os objetos para a DTO
        return data.map((json) => MessageDto.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Failed to parse messages: $e');
      }
    } else {
      throw Exception(
          'Failed to fetch messages: ${response.statusCode} ${response.body}');
    }
  }


  // Send a new message to a chat
  Future<MessageDto> sendMessage(String chatId, String employeeId, String text) async {
  final url = Uri.parse('$_baseUrl/$chatId/sendMessage?employeeId=$employeeId');
  final response = await client.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'text': text,
    }),
  );

  if (response.statusCode == 201) {
    return MessageDto.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to send message');
  }
}


  // Delete a message by its ID
  Future<void> deleteMessage(String messageId) async {
    final response = await client.delete(Uri.parse('$_baseUrl/deleteMessage/$messageId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }
}