import 'package:flutter_test/flutter_test.dart';
import 'package:front_end_moldme/dtos/create_task_dto.dart';
import 'package:front_end_moldme/dtos/task_dto.dart';
import 'package:front_end_moldme/services/task_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mockito/annotations.dart';
import 'payment_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late TaskService taskService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    taskService = TaskService(client: mockClient);
  });

  test('getTasksByProjectId returns a list of TaskDto on success', () async {
    const projectId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';
    final mockResponse = [
      {
        "taskId": "1",
        "titleName": "Task 1",
        "description": "Description 1",
        "date": "2023-10-01T00:00:00Z",
        "status": 0,
        "projectId": projectId,
        "employeeId": "employee1",
        "fileContent": null,
        "fileName": null,
        "mimeType": null,
      },
      {
        "taskId": "2",
        "titleName": "Task 2",
        "description": "Description 2",
        "date": "2023-10-02T00:00:00Z",
        "status": 1,
        "projectId": projectId,
        "employeeId": "employee2",
        "fileContent": null,
        "fileName": null,
        "mimeType": null,
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Task/project/$projectId/tasks'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await taskService.getTasksByProjectId(projectId);

    // Assertions
    expect(result, isA<List<TaskDto>>());
    expect(result.length, 2);
    expect(result.first.titleName, "Task 1");
  });

  test('createTask returns success message on success', () async {
    const projectId = '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08';
    const employeeId = '675943a6-6a50-40b9-a1c3-168b9dfc87a9';
    final createTaskDto = CreateTaskDto(
      titleName: "New Task",
      description: "New Task Description",
      date: DateTime.now(),
      status: 0,
      fileContent: null,
      fileName: null,
      mimeType: null,
    );

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Task/webTaskcreate?projectId=$projectId&employeeId=$employeeId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Task created successfully', 201));

    // Perform the service call
    final result = await taskService.createTask(createTaskDto, projectId, employeeId);

    // Assertions
    expect(result, 'Task created successfully');
  });

  test('deleteTask returns success message on success', () async {
    const taskId = '1';

    // Mock the HTTP DELETE request
    when(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Task/delete/$taskId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Task deleted successfully', 204));

    // Perform the service call
    await taskService.deleteTask(taskId);

    // Verify the call
    verify(mockClient.delete(
      Uri.parse('http://localhost:5213/api/Task/delete/$taskId'),
      headers: anyNamed('headers'),
    )).called(1);
  });

  test('updateTask returns success message on success', () async {
    final taskDto = TaskDto(
      taskId: "1",
      titleName: "Updated Task",
      description: "Updated Description",
      date: DateTime.now().toIso8601String(),
      status: 1,
      projectId: "projectId",
      employeeId: "employeeId",
      fileContent: null,
      fileName: null,
      mimeType: null,
    );

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse('http://localhost:5213/api/Task/updateTask/${taskDto.taskId}'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Task updated successfully', 200));

    // Perform the service call
    await taskService.updateTask(taskDto);

    // Verify the call
    verify(mockClient.put(
      Uri.parse('http://localhost:5213/api/Task/updateTask/${taskDto.taskId}'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).called(1);
  });
}