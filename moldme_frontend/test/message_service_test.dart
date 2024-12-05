import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_end_moldme/services/message_service.dart';
import 'package:front_end_moldme/dtos/message_dto.dart';
import 'package:mockito/annotations.dart';
import 'message_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MessageService messageService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    messageService = MessageService(client: mockClient);
  });

  test('getMessages returns a list of MessageDto on success', () async {
    const chatId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';
    final mockResponse = [
      {
        "messageId": "1",
        "date": "2023-10-01T00:00:00Z",
        "text": "Message 1",
        "employeeId": "employee1",
        "chatId": chatId,
      },
      {
        "messageId": "2",
        "date": "2023-10-02T00:00:00Z",
        "text": "Message 2",
        "employeeId": "employee2",
        "chatId": chatId,
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Message/$chatId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await messageService.getMessages(chatId);

    // Assertions
    expect(result, isA<List<MessageDto>>());
    expect(result.length, 2);
    expect(result.first.text, "Message 1");
  });

  test('getMessages throws exception on failure', () async {
    const chatId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Message/$chatId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(
        () async => await messageService.getMessages(chatId), throwsException);
  });

  test('sendMessage returns MessageDto on success', () async {
    const chatId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';
    const employeeId = '675943a6-6a50-40b9-a1c3-168b9dfc87a9';
    const text = 'New Message';
    final mockResponse = {
      "messageId": "1",
      "text": text,
      "date": "2023-10-01T00:00:00Z",
      "chatId": chatId,
      "employeeId": employeeId,
    };

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse(
          'http://localhost:5213/api/Message/$chatId/sendMessage?employeeId=$employeeId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 201));

    // Perform the service call
    final result = await messageService.sendMessage(chatId, employeeId, text);

    // Assertions
    expect(result, isA<MessageDto>());
    expect(result.text, text);
  });

  test('sendMessage throws exception on failure', () async {
    const chatId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';
    const employeeId = '675943a6-6a50-40b9-a1c3-168b9dfc87a9';
    const text = 'New Message';

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Message/$chatId/sendMessage?employeeId=$employeeId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(() async => await messageService.sendMessage(chatId, employeeId, text), throwsException);
  });

  test('deleteMessage returns success message on success', () async {
    const messageId = '1';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Message/deleteMessage/$messageId'),
      headers: anyNamed('headers'),
    )).thenAnswer(
        (_) async => http.Response('Message deleted successfully', 200));

    // Perform the service call
    await messageService.deleteMessage(messageId);

    // Verify the call
    verify(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Message/deleteMessage/$messageId'),
      headers: anyNamed('headers'),
    )).called(1);
  });

  test('deleteMessage throws exception on failure', () async {
    const messageId = '1';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Message/deleteMessage/$messageId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(() async => await messageService.deleteMessage(messageId), throwsException);
  });
}
