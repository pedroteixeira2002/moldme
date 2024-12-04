import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/message_dto.dart';


class MessageService {
  static const String _baseUrl = 'http://localhost:5213/api/Message';

  // Get messages for a specific chat
Future<List<MessageDto>> getMessages(String chatId) async {
  final response = await http.get(Uri.parse('$_baseUrl/$chatId'));

  if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is Map && jsonResponse.containsKey('\$values')) {
        final List<dynamic> messagesJson = jsonResponse['\$values'];
        return messagesJson.map((json) => MessageDto.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load messages');
    }
}

  // Send a new message to a chat
  Future<MessageDto> sendMessage(String chatId, String employeeId, String text) async {
  final url = Uri.parse('$_baseUrl/$chatId/sendMessage?employeeId=$employeeId');
  final response = await http.post(
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
    final response = await http.delete(Uri.parse('$_baseUrl/deleteMessage/$messageId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }
}
