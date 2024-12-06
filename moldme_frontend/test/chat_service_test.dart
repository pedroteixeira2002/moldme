import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_end_moldme/services/chat_service.dart';
import 'package:front_end_moldme/dtos/chat_dto.dart';
import 'package:mockito/annotations.dart';
import 'chat_service_test.mocks.dart';// Mock http.Client using Mockito
@GenerateMocks([http.Client])
void main() {
  late ChatService chatService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    chatService = ChatService(client: mockClient);
  });

  test('createChat returns true on success', () async {
    const projectId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('https://localhost:5123/api/Chat/createChat'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('', 200));

    // Perform the service call
    final result = await chatService.createChat(projectId);

    // Assertions
    expect(result, true);
  });

  test('createChat returns false on failure', () async {
    const projectId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('https://localhost:5123/api/Chat/createChat'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('', 500));

    // Perform the service call
    final result = await chatService.createChat(projectId);

    // Assertions
    expect(result, false);
  });

  test('deleteChat returns true on success', () async {
    const chatId = '1';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('https://localhost:5123/api/Chat/deleteChat/$chatId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('', 200));

    // Perform the service call
    final result = await chatService.deleteChat(chatId);

    // Assertions
    expect(result, true);
  });
  
  test('deleteChat returns false on failure', () async {
    const chatId = '1';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('https://localhost:5123/api/Chat/deleteChat/$chatId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('', 500));

    // Perform the service call
    final result = await chatService.deleteChat(chatId);

    // Assertions
    expect(result, false);
  });
  test('deleteChat returns false on failure', () async {
    const chatId = '1';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('https://localhost:5123/api/Chat/deleteChat/$chatId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('', 500));

    // Perform the service call
    final result = await chatService.deleteChat(chatId);

    // Assertions
    expect(result, false);
  });
}