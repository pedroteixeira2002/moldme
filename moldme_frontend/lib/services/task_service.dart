import 'dart:typed_data';
import 'package:front_end_moldme/dtos/create_task_dto.dart';
import 'package:front_end_moldme/dtos/task_dto.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:5213/api/Task"));
  final String baseUrl = 'http://localhost:5213/api/Task';
  Future<String> createTask(
      CreateTaskDto taskDto, String projectId, String employeeId) async {
    try {
      
      final response = await _dio.post(
        '/webTaskcreate',
        queryParameters: {'projectId': projectId, 'employeeId': employeeId},
        data: taskDto.toJson(),
      );
      return response.data; // "Task created successfully"
    } catch (e) {
      throw Exception("Failed to create task: $e");
    }
  }

  Future<List<TaskDto>> getTasksByProjectId(String projectId) async {
    try {
      final response = await _dio.get('/project/$projectId/tasks');
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = response.data;
        return jsonResponse.map((json) => TaskDto.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception("Failed to load tasks: $e");
    }
  }






  Future<TaskDto> getTaskById(String taskId) async {
    try {
      final response = await _dio.get('/task/$taskId');
      return TaskDto.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to fetch task: $e");
    }
  }

  Future<void> updateTask(TaskDto task) async {
    try {
      final response = await _dio.put(
        '/updateTask/${task.taskId}',
        data: task.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      throw Exception("Failed to update task: $e");
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await _dio.delete('/delete/$taskId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      throw Exception("Failed to delete task: $e");
    }
  }

  Future<Uint8List> downloadFile(String taskId) async {
    final url = '$baseUrl/task/$taskId/file';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download file');
    }
  }
}
