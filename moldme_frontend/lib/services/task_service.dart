import 'dart:convert';
import 'dart:typed_data';
import 'package:front_end_moldme/dtos/create_task_dto.dart';
import 'package:front_end_moldme/dtos/task_dto.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String baseUrl = 'http://localhost:5213/api/Task';
  final http.Client client;

  TaskService({http.Client? client}) : client = client ?? http.Client();

  Future<String> createTask(CreateTaskDto taskDto, String projectId, String employeeId) async {
    final url = Uri.parse('$baseUrl/webTaskcreate?projectId=$projectId&employeeId=$employeeId');
    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(taskDto.toJson()),
      );
      if (response.statusCode == 201) {
        return response.body; // "Task created successfully"
      } else {
        throw Exception('Failed to create task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<List<TaskDto>> getTasksByProjectId(String projectId) async {
    final url = Uri.parse('$baseUrl/project/$projectId/tasks');
    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((json) => TaskDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<TaskDto> getTaskById(String taskId) async {
    final url = Uri.parse('$baseUrl/task/$taskId');
    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return TaskDto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  Future<void> updateTask(TaskDto task) async {
    final url = Uri.parse('$baseUrl/updateTask/${task.taskId}');
    try {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final url = Uri.parse('$baseUrl/delete/$taskId');
    try {
      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<Uint8List> downloadFile(String taskId) async {
    final url = Uri.parse('$baseUrl/task/$taskId/file');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download file: ${response.body}');
    }
  }
}