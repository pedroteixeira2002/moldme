import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/message_dto.dart';


class MessageService {
  final String baseUrl;

  MessageService({required this.baseUrl});

  // Get messages for a specific chat
  Future<List<MessageDto>> getMessages(String chatId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/message/$chatId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => MessageDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // Send a new message to a chat
  Future<MessageDto> sendMessage(String chatId, String employeeId, MessageDto messageDto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/message/$chatId/sendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'text': messageDto.text,
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
    final response = await http.delete(Uri.parse('$baseUrl/api/message/deleteMessage/$messageId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }
}
